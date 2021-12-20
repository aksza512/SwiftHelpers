//
//  SwiftUIView.swift
//  
//
//  Created by Márk József Alexa on 2021. 12. 19..
//

import SwiftUI

public struct FullHeightScrollView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                content().frame(minHeight: geometry.size.height)
            }
        }
    }
}
