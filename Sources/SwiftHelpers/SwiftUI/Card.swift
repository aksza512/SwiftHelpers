//
//  SwiftUIView.swift
//  
//
//  Created by Márk József Alexa on 2021. 12. 19..
//

import SwiftUI

public struct Card<Content: View>: View {
    let cornerRadius: CGFloat
    let padding: CGFloat
    let backgroundColor: Color
    @ViewBuilder let content: () -> Content

    public init(
        cornerRadius: CGFloat = .l,
        padding: CGFloat = .m,
        backgroundColor: Color = .white,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        VStack(spacing: 0) {
            content()
                .padding(padding)
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            Card {
                Text("Hello - bello")
                    .padding()
            }
        }
    }
}
