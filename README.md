# IsScrolling

![](https://img.shields.io/badge/Platform%20Compatibility-iOS%20|%20macOS%20|%20macCatalyst-red)

[中文版说明](https://github.com/fatbobman/IsScrolling/blob/main/READMECN.md)

As the name suggests, IsScrolling provides a ViewModifier to get the current scrolling state of a ScrollView or List in SwiftUI. IsScrolling has good backward and forward compatibility since it is fully implemented natively in SwiftUI.

## Motivation

When I was developing [SwipeCell](https://github.com/fatbobman/SwipeCell) two years ago, I needed to close the opened side-swipe menu when the scrollable component (ScrollView, List) started scrolling. This was achieved by injecting a Delegate into the scrollable component via [Introspect](https://github.com/siteline/SwiftUI-Introspect.git), and I've been planning to replace this with a more native solution. 

## Usage

IsScrolling has two modes, each based on a different implementation principle:

* exclusion

  Supports iOS only, no need to add sensors to the views of scrollable component, only one scrollable component in the screen

```swift
struct VStackExclusionDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(0..<100) { i in
                        CellView(index: i) // no need to add sensor in exclusion mode
                    }
                }
            }
            .scrollStatusMonitor($isScrolling, monitorMode: .exclusion) // add scrollStatusMonitor to get scroll status
        }
    }
}

struct CellView: View {
    @Environment(\.isScrolling) var isScrolling // can get scroll status in scrollable content
    let index: Int
    var body: some View {
        Rectangle()
            .fill(colors[index % colors.count].opacity(0.6))
            .frame(maxWidth: .infinity, minHeight: 80)
            .overlay(Text("ID: \(index) Scrolling: \(isScrolling ? "T" : "F")"))
    }
}
```

* common

  Available for all platforms, monitors multiple scrollable components in the screen at the same time, requires sensor to be added to the views of scrollable component.

```swift
struct ListCommonDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            List {
                ForEach(0..<100) { i in
                    CellView(index: i)
                        .scrollSensor() // Need to add sensor for each subview
                }
            }
            .scrollStatusMonitor($isScrolling, monitorMode: .common)
        }
    }
}
```

For combinations like ScrollView + VStack (HStack), just add one scrollSensor to the scrollable view. For combinations like List, ScrollView + LazyVStack (LazyHStack), you need to add a scrollSensor for each child view.

For details, please check [Demo](https://github.com/fatbobman/IsScrolling/tree/main/Demo)

## Limitations and Shortcomings

No matter which monitoring mode IsScrolling provides, it cannot be 100% accurate. After all, IsScrolling inferred the current scrolling state of a scrollable component from certain external phenomena. Known issues are.

* When the scrolling content is at the top or bottom of the container and in a bouncy state, clicking on it to stop scrolling and then releasing it may result in a perturbation of the scrolling state (the state changes rapidly once,This situation also exists even with UIScrollViewDelegate)
* When the content in the scrollable component changes in size or position not caused by scrolling (for example, the size of a view in a List changes dynamically), IsScrolling may mistakenly judge that scrolling has occurred in common mode, but in the view After the change is over, the state will immediately return to the end of the scroll
* After the scrolling starts (the status has changed to scrolling ), stop scrolling, but the finger is still in the pressed state, the common mode will regard this as the end of the scrolling, and the exclusion mode will still keep the scrolling state until the finger ends pressing

## Requirements

```
.iOS(.v14),

.macOS(.v12),

.macCatalyst(.v14),
```

## Installation

```
dependencies: [
  .package(url: "https://github.com/fatbobman/IsScrolling.git", from: "1.0.0")
]
```

## License

This library is released under the MIT license. See [LICENSE](https://github.com/fatbobman/IsScrolling/blob/main/LICENSE) for details.
