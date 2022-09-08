//
//  HStackDemo.swift
//  Demo
//
//  Created by Yang Xu on 2022/9/7.
//

import Foundation
import IsScrolling
import SwiftUI

#if !os(macOS) && !targetEnvironment(macCatalyst)
struct HStackExclusionDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<100) { i in
                        HCellView(index: i)
                    }
                }
            }
            .scrollStatusMonitor($isScrolling, monitorMode: .exclusion)
            Text("Scrolling : \(isScrolling ? "True" : "False")")
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
        }
    }
}
#endif

struct HStackCommonDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<100) { i in
                        HCellView(index: i)
                    }
                }
                .scrollSensor(.horizontal) // change axis to horizontal
            }
            .scrollStatusMonitor($isScrolling, monitorMode: .common)

            Text("Scrolling : \(isScrolling ? "True" : "False")")
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
        }
    }
}

struct HCellView: View {
    @Environment(\.isScrolling) private var isScrolling
    let index: Int
    let showText: Bool

    init(index: Int, showText: Bool = true) {
        self.index = index
        self.showText = showText
    }

    var body: some View {
        Rectangle()
            .fill(colors[index % colors.count].opacity(0.6))
            .frame(width: 100, height: 200)
            .overlay(
                VStack {
                    if showText {
                        Text("ID: \(index)")
                        Text("Scrolling: \(isScrolling ? "T" : "F")")
                    }
                }
            )
    }
}
