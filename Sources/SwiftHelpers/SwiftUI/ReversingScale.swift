//
//  SwiftUIView.swift
//  
//
//  Created by Márk József Alexa on 2022. 02. 10..
//

import SwiftUI

public struct ReversingScale: AnimatableModifier {
    public var value: CGFloat

    private var target: CGFloat
    private var onEnded: () -> ()

    public init(to value: CGFloat, onEnded: @escaping () -> () = {}) {
        self.target = value
        self.value = value
        self.onEnded = onEnded // << callback
    }

    public var animatableData: CGFloat {
        get { value }
        set { value = newValue
            // newValue here is interpolating by engine, so changing
            // from previous to initially set, so when they got equal
            // animation ended
            if newValue == target {
                DispatchQueue.main.async { [self] in
                    self.onEnded()
                }
            }
        }
    }

    public func body(content: Content) -> some View {
        content.scaleEffect(value)
    }
}
