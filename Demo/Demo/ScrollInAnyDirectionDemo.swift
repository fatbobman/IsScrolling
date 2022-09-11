//
//  ScrollInAnyDirectionDemo.swift
//  Demo
//
//  Created by Yang Xu on 2022/9/11.
//

import Foundation
import IsScrolling
import SwiftUI

struct ScrollInAnyDirectionDemo: View {
    @State var isScrolling = false
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            Rectangle()
                .fill(LinearGradient(colors: [.red, .orange, .yellow, .pink, .cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 3000, height: 3000)
                .scrollSensor()
        }
        .scrollStatusMonitor($isScrolling, monitorMode: .common)
        .overlay(
            Text("Scrolling: \(isScrolling ? "True" : "False")")
        )
    }
}
