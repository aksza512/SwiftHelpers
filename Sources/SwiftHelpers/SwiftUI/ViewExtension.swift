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

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
