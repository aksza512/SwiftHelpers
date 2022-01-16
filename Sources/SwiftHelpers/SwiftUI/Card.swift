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
    let title: String?
    @ViewBuilder let content: () -> Content

    public init(
        title: String? = nil,
        cornerRadius: CGFloat = .l,
        padding: CGFloat = .m,
        backgroundColor: Color = .white,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
        self.backgroundColor = backgroundColor
        self.title = title
    }

    public var body: some View {
        VStack(spacing: .s) {
            if let title = title {
                HStack {
                    Text(title)
                        .font(.headings4)
                    Spacer()
                }
            }
            VStack(spacing: 0) {
                content()
                    .padding(padding)
            }
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            VStack(spacing: .xxxl) {
                Card {
                    Text("Teszt")
                        .frame(maxWidth: .infinity)
                }
                Card(title: "Title") {
                    Text("Teszt")
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
    }
}
