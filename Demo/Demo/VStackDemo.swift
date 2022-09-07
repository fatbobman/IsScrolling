//
//  VStackDemo.swift
//  Demo
//
//  Created by Yang Xu on 2022/9/7.
//

import Foundation
import IsScrolling
import SwiftUI

struct VStackExclusionDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            ScrollView {
                VStack {
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

struct VStackCommonDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(0..<100) { i in
                        CellView(index: i)
                    }
                }
                .scrollSensor(.vertical) // only need one sensor for whole content in ScrollView
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
