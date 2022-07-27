//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2022. 01. 16..
//

import SwiftUI
import UIKit

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
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func textEditorBackground<V>(@ViewBuilder _ content: () -> V) -> some View where V : View {
        self
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
            .background(content())
    }
    
    @ViewBuilder
    func backgroundColor(_ color: Color) -> some View {
        // TODO: ios16-tól mehet a dolog
//        if #available(iOS 16, *) {
//            self.scrollContentBackground(color)
//        }
//        else {
            self.background(color)
//        }
    }}

public struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.edgeInsets ?? EdgeInsets()
    }
}

private extension UIEdgeInsets {
    var edgeInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

public extension EnvironmentValues {
    var keyWindowSafeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
