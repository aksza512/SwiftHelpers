//
//  File.swift
//  
//
//  Created by Alexa Márk on 2022. 03. 27..
//

import UIKit

public extension UIApplication {
    static func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    var keyWindow: UIWindow? {
         // Get connected scenes
         return UIApplication.shared.connectedScenes
             // Keep only active scenes, onscreen and visible to the user
             .filter { $0.activationState == .foregroundActive }
             // Keep only the first `UIWindowScene`
             .first(where: { $0 is UIWindowScene })
             // Get its associated windows
             .flatMap({ $0 as? UIWindowScene })?.windows
             // Finally, keep only the key window
             .first(where: \.isKeyWindow)
    }
}
