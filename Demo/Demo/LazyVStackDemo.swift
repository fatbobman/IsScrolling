//
//  LazyVStackDemo.swift
//  Demo
//
//  Created by Yang Xu on 2022/9/7.
//

import Foundation
import IsScrolling
import SwiftUI

#if !os(macOS) && !targetEnvironment(macCatalyst)
struct LazyVStackExclusionDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<100) { i in
                        CellView(index: i)
                    }
                }
            }
            .scrollStatusMonitor($isScrolling, monitorMode: .exclusion)
            .safeAreaInset(edge: .bottom) {
                Text("Scrolling : \(isScrolling ? "True" : "False")")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
            }
        }
    }
}
#endif

struct LazyVStackCommonDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<100) { i in
                        CellView(index: i)
                            .scrollSensor() // Need to add sensor for each subview
                    }
                }
            }
            .scrollStatusMonitor($isScrolling, monitorMode: .common)
            .safeAreaInset(edge: .bottom) {
                Text("Scrolling : \(isScrolling ? "True" : "False")")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
            }
        }
    }
}
