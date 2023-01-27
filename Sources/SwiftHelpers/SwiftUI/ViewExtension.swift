//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2022. 01. 16..
//

import SwiftUI
import UIKit

public extension View {
    var anyView: AnyView {
        AnyView(self)
    }

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
#warning("TODO: ios16-tól mehet a dolog")
//        if #available(iOS 16, *) {
//            self.scrollContentBackground(color)
//        }
//        else {
            self.background(color)
//        }
    }
    
    func snapshot() -> UIImage {
//        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
//        let view = controller.view
//
//        let targetSize = controller.view.intrinsicContentSize
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
        
        
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.top))
                let view = controller.view
                let targetSize = controller.view.intrinsicContentSize
                view?.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize)
                view?.backgroundColor = .clear

                let format = UIGraphicsImageRendererFormat()
                format.scale = 3 // Ensures 3x-scale images. You can customise this however you like.
                let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
                return renderer.image { _ in
                    view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
                }
     }
    
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }

    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
         ZStack(alignment: alignment) {
             placeholder().opacity(shouldShow ? 1 : 0)
             self
         }
     }

    func placeholder(_ text: String, font: Font = .textMedium,  color: Color, when shouldShow: Bool, alignment: Alignment = .leading) -> some View {
        placeholder(when: shouldShow, alignment: alignment) {
            Text(text)
                .font(font)
                .foregroundColor(color)
        }
    }
}

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
        UIApplication.shared.firstKeyWindow?.safeAreaInsets.edgeInsets ?? EdgeInsets()
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
