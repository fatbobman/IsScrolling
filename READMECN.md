# IsScrolling

![](https://img.shields.io/badge/Platform%20Compatibility-iOS%20|%20macOS%20|%20macCatalyst-red)

正如名称所示，IsScrolling 提供了一个 ViewModifier ，用来获取 SwiftUI 中 ScrollView 或 List 当前的滚动状态。由于完全采用了 SwiftUI 原生的方式实现此功能，因此 IsScrolling 具备了很好的前后兼容性。

## 动机

在两年前开发 [SwipeCell](https://github.com/fatbobman/SwipeCell) 的时候，我需要在可滚动组件（ ScrollView、List ）开始滚动时，关闭已经打开的侧滑菜单。当时是通过  [Introspect](https://github.com/siteline/SwiftUI-Introspect.git) 为可滚动组件注入了一个 Delegate 才达到此目的，一直打算用更加原生的方式替代此方案。 

## 使用方法

IsScrolling 拥有两种模式，它们分别基于了不同的实现原理：

* exclusion

  仅支持 iOS ，无需为滚动视图添加 sensor ，屏幕中仅能有一个可滚动组件

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

  适用于全部平台，可同时监控屏幕中的多个可滚动组件，需要为视图添加 sensor

```swift
struct ListCommonDemo: View {
    @State var isScrolling = false
    var body: some View {
        VStack {
            List {
                ForEach(0..<100) { i in
                    CellView(index: i)
                        .scrollSensor(.vertical) // Need to add sensor for each subview
                }
            }
            .scrollStatusMonitor($isScrolling, monitorMode: .common)
        }
    }
}
```

对于 ScrollView + VStack（ HStack ）这类的组合，只需为可滚动视图添加一个 scrollSensor 即可。对于 List、ScrollView + LazyVStack（ LazyHStack ）这类的组合，需要为每个子视图都添加一个 scrollSensor。

当 ScrollView 为横向滚动时，需要将 scrollSensor 的 axis 参数设置为 horizontal

详细内容，请查看 [Demo](https://github.com/fatbobman/IsScrolling/tree/main/Demo)

## 限制与不足

无论采用 IsScrolling 提供的哪种监控模式，都无法做到 100% 的准确。毕竟 IsScrolling 是通过某些外在的现象来推断可滚动组件的当前滚动状态。已知的问题有：

* 当滚动内容处于容器的顶部或底部且处于回弹状态时，此时点击停止滚动，再松手，可能会出现滚动状态的扰动（ 状态会快速变化一次 ）
* 当可滚动组件中的内容出现了非滚动引起的尺寸或位置的变化（ 例如 List 中某个视图的尺寸发生了动画变化 ），IsScrolling 可能会误判断为发生了滚动，但在视图的变化结束后，状态会马上恢复到滚动结束

## 需求

```
.iOS(.v14),

.macOS(.v12),

.macCatalyst(.v14),
```

## 安装

```
dependencies: [
  .package(url: "https://github.com/fatbobman/IsScrolling.git", from: "1.0.0")
]
```

## 版权

This library is released under the MIT license. See [LICENSE](https://github.com/fatbobman/IsScrolling/blob/main/LICENSE) for details.
