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
                NavigationLink("VStack - Exclusion") { VStackExclusionDemo() }
                NavigationLink("VStack - Common") { VStackCommonDemo() }
                NavigationLink("LazyVStack - Exclusion") { LazyVStackExclusionDemo() }
                NavigationLink("LazyVStack - Common") { LazyVStackCommonDemo() }
                NavigationLink("List - Exclusion") { ListExclusionDemo() }
                NavigationLink("List - Common") { ListCommonDemo() }
                NavigationLink("HStack - Exclusion") { HStackExclusionDemo() }
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

struct LazyVStackDemo: View {
    var body: some View {
        Text("")
    }
}

struct ListDemo: View {
    var body: some View {
        Text("")
    }
}
