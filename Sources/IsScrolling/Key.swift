//
//  Key.swift
//  
//
//  Created by Yang Xu on 2022/9/7.
//

import Foundation
import SwiftUI

struct IsScrollingValueKey: EnvironmentKey {
    static var defaultValue = false
}

public extension EnvironmentValues {
    var isScrolling: Bool {
        get { self[IsScrollingValueKey.self] }
        set { self[IsScrollingValueKey.self] = newValue }
    }
}

struct MinValueKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = nextValue()
    }
}
