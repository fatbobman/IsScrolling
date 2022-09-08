//
//  ContentView.swift
//  Demo
//
//  Created by Yang Xu on 2022/9/7.
//

import IsScrolling
import SwiftUI

struct ContentView: View {
    @State var selection = 0
    var body: some View {
        NavigationView {
            List {
                #if !os(macOS) && TARGET_OS_MACCATALYST
                NavigationLink("VStack - Exclusion") { VStackExclusionDemo() }
                #endif

                NavigationLink("VStack - Common") { VStackCommonDemo() }
                #if !os(macOS) && TARGET_OS_MACCATALYST
                NavigationLink("LazyVStack - Exclusion") { LazyVStackExclusionDemo() }
                #endif

                NavigationLink("LazyVStack - Common") { LazyVStackCommonDemo() }

                #if !os(macOS) && TARGET_OS_MACCATALYST
                NavigationLink("List - Exclusion") { ListExclusionDemo() }
                #endif

                NavigationLink("List - Common") { ListCommonDemo() }

                #if !os(macOS) && TARGET_OS_MACCATALYST
                NavigationLink("HStack - Exclusion") { HStackExclusionDemo() }
                #endif

                NavigationLink("HStack - Common") { HStackCommonDemo() }
                NavigationLink("MultiMonitor - Common") { MultiScrollableComponentsDemo() }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let colors = [Color.red, .cyan, .yellow, .orange, .orange, .blue, .brown, .indigo]

struct CellView: View {
    @Environment(\.isScrolling) var isScrolling
    let index: Int
    var body: some View {
        Rectangle()
            .fill(colors[index % colors.count].opacity(0.6))
            .frame(maxWidth: .infinity, minHeight: 80)
            .overlay(Text("ID: \(index) Scrolling: \(isScrolling ? "T" : "F")"))
    }
}
