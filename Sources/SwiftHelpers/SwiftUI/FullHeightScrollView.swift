//
//  SwiftUIView.swift
//  
//
//  Created by Márk József Alexa on 2021. 12. 19..
//

import SwiftUI

@available(iOS 15.0, *)
public struct FullHeightScrollView<Content: View>: View {
    @ViewBuilder let content: (ScrollViewProxy) -> Content
    public init(
        @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
    ) {
        self.content = content
    }

    public var body: some View {
        ScrollViewReader { proxy in
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    content(proxy).frame(minHeight: geometry.size.height, alignment: .top)
                }
            }
        }
    }
}
