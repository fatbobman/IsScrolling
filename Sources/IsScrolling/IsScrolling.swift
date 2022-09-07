//
//  ScrollStatusMonitor.swift
//
//
//  Created by Yang Xu on 2022/9/7.
//

import Combine
import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func scrollStatusMonitor(_ isScrolling: Binding<Bool>, monitorMode: ScrollStatusMonitorMode) -> some View {
        switch monitorMode {
        case .common:
            modifier(ScrollStatusMonitorCommonModifier(isScrolling: isScrolling))
        case .exclusion:
            modifier(ScrollStatusMonitorExclusionModifier(isScrolling: isScrolling))
        }
    }

    func scrollSensor(_ axis: Axis = .vertical) -> some View {
        overlay(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: MinValueKey.self,
                        value: axis == .vertical ? proxy.frame(in: .global).minY : proxy.frame(in: .global).minX
                    )
            }
        )
    }
}

struct ScrollStatusMonitorExclusionModifier: ViewModifier {
    @StateObject private var store = ExclusionStore()
    @Binding var isScrolling: Bool
    func body(content: Content) -> some View {
        content
            .environment(\.isScrolling, store.isScrolling)
            .onChange(of: store.isScrolling) { value in
                isScrolling = value
            }
            .onDisappear {
                store.cancellable = nil
            }
    }
}

final class ExclusionStore: ObservableObject {
    @Published var isScrolling = false

    private let idlePublisher = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    private let scrollingPublisher = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()

    private var publisher: some Publisher {
        scrollingPublisher
            .map { $0.timeIntervalSince1970 }
            .merge(with:
                idlePublisher
                    .map { _ in
                        0
                    }
            )
    }

    var cancellable: AnyCancellable?

    init() {
        cancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { output in
                guard let timestamp = output as? TimeInterval else { return }
                if timestamp != 0,!self.isScrolling {
                    self.isScrolling = true
                } else if timestamp == 0, self.isScrolling {
                    self.isScrolling = false
                }
            })
    }
}

struct ScrollStatusMonitorCommonModifier: ViewModifier {
    @StateObject private var store = CommonStore()
    @Binding var isScrolling: Bool
    func body(content: Content) -> some View {
        content
            .environment(\.isScrolling, store.isScrolling)
            .onChange(of: store.isScrolling) { value in
                isScrolling = value
            }
            .onPreferenceChange(MinValueKey.self) { _ in
                store.preferencePublisher.send(Date().timeIntervalSince1970)
            }
            .onDisappear {
                store.cancellable = nil
            }
    }
}

final class CommonStore: ObservableObject {
    @Published var isScrolling = false
    private var timestamp: TimeInterval = 0

    private let idlePublisher = Timer.publish(every: 0.2, on: .main, in: .default).autoconnect()
    let preferencePublisher = PassthroughSubject<TimeInterval, Never>()

    private var publisher: some Publisher {
        preferencePublisher
            .removeDuplicates()
            .merge(with:
                idlePublisher
                    .map { _ in
                        self.timestamp
                    }
            )
    }

    var cancellable: AnyCancellable?

    init() {
        cancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { output in
                guard let timestamp = output as? TimeInterval else { return }
                guard self.timestamp != 0 else {
                    self.timestamp = timestamp
                    return
                }

                if timestamp != self.timestamp,!self.isScrolling {
                    self.isScrolling = true
                } else if timestamp == self.timestamp, self.isScrolling {
                    self.isScrolling = false
                }
                self.timestamp = timestamp
            })
    }
}

/// Monitoring mode for scroll status
public enum ScrollStatusMonitorMode {
    /// The judgment of the start and end of scrolling is more accurate and timely.
    ///
    /// But only for scenarios where there is only one scrollable component in the screen
    case exclusion

    /// This mode should be used when there are multiple scrollable parts in the scene.
    ///
    /// * The accuracy and timeliness are slightly inferior to the exclusion mode.
    /// * When using this mode, a **scroll sensor** must be added to the subview of the scroll widget.
    /// * When the scrolling view enters the rebound state, if user stop scrolling at this point, the scrolling state may be jittery (usually only once)
    /// * When monitoring multiple scrollable components, if more than one component is scrolling at the same time, it will only turn into a stopped state when **all scrolling components are stopped**
    case common
}
