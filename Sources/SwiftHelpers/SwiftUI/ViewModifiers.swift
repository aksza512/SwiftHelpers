//
//  File.swift
//  
//
//  Created by Alexa Márk on 2022. 08. 17..
//

import SwiftUI

// A view modifier that detects shaking and calls a function of our choosing.
public struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    public func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}
