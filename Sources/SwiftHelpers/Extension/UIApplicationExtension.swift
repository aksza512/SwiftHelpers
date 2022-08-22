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
    
    var firstKeyWindow: UIWindow? {
        return self
        .connectedScenes
        .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
        .first { $0.isKeyWindow }
    }
}
