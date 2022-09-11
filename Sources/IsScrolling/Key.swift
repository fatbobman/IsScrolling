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

public struct MinValueKey: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    public static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

