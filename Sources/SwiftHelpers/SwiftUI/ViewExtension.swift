//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2022. 01. 16..
//

import SwiftUI

public extension View {
    @ViewBuilder
    func onAppear(after timeInterval: TimeInterval, action: @escaping () -> Void) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                action()
            }
        }
    }

    @available(iOS 14.0, *)
    @ViewBuilder
    func redacted(when condition: Bool) -> some View {
        if !condition {
            redacted(reason: [])
        } else {
            redacted(reason: .placeholder)
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
