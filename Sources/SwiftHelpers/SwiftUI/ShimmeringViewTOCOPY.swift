//
//  SwiftUIView 2.swift
//  
//
//  Created by Márk József Alexa on 2021. 12. 19..
//

import Foundation
import SwiftUI

extension Gradient {
    static func shimmer(for background: Color) -> Gradient {
        Gradient(stops: [
            .init(color: .gray, location: 0),
            .init(color: .gray, location: 0.125),
            .init(color: UIColor.white.color, location: 0.188),
            .init(color: .gray, location: 0.250),
            .init(color: .gray, location: 1)
        ])
    }
}

@available(iOS 15.0, *)
public struct ShimmeringView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    private let content: () -> Content
    private let gradient: Gradient

    public init(gradient: Gradient, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.gradient = gradient
    }

    public var body: some View {
        ZStack {
            content()
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    let offset: Double = now.truncatingRemainder(dividingBy: 2)

                    let start = CGPoint(x: -size.width * (7 - (offset * 3.5)), y: 0)
                    let rect = CGRect(
                        origin: start,
                        size: .init(
                            width: size.width * 8,
                            height: size.height
                        )
                    )
                    let path = Path(rect)
                    let gradientStart = CGPoint(
                        x: start.x,
                        y: 0.5 * size.height
                    )
                    let gradientEnd = CGPoint(
                        x: start.x + (size.width * 8),
                        y: 0.5 * size.height
                    )
                    context.fill(
                        path,
                        with: .linearGradient(
                            gradient,
                            startPoint: gradientStart,
                            endPoint: gradientEnd
                        )
                    )
                }
            }.blendMode(colorScheme == .light ? .lighten : .darken)
        }
    }
}

@available(iOS 15.0, *)
public struct ShimmerModifier: ViewModifier {
    let gradient: Gradient
    public func body(content: Content) -> some View {
        ShimmeringView(gradient: gradient) { content }
    }
}

@available(iOS 15.0, *)
public extension View {
    @ViewBuilder
    func shimmeringPlaceholder(when condition: Bool, for background: Color) -> some View {
        if condition {
            redacted(reason: .placeholder)
                .modifier(ShimmerModifier(gradient: .shimmer(for: background)))
        } else {
            self
        }
    }
}

@available(iOS 15.0, *)
struct ShimmeringView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ZStack {
                Card {
                    Text("asdfékasdéf")
                }
                .foregroundColor(Color.black)
            }
            .shimmeringPlaceholder(when: true, for: .red)
        }.preferredColorScheme(.light)
    }
}
