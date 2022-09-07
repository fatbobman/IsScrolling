//
//  MultiMonitor.swift
//  Demo
//
//  Created by Yang Xu on 2022/9/7.
//

import Foundation
import IsScrolling
import SwiftUI

struct MultiScrollableComponentsDemo: View {
    @State var isScrolling1 = false
    @State var isScrolling2 = false
    var body: some View {
        VStack(spacing:30) {
            HStackCommonDemo()
            VStackCommonDemo()
        }
    }
}
