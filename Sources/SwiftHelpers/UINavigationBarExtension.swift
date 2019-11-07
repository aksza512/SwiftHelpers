//
//  File.swift
//  
//
//  Created by Alexa Márk on 2019. 11. 07..
//

import UIKit

public extension UINavigationBar {
    func preferLargeTitle() {
        prefersLargeTitles = false
    }
    
    func clearBackground() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
    
    func setTitleColor(_ color: UIColor?) {
        guard let color = color else { return }
        let textAttributes = [NSAttributedString.Key.foregroundColor:color]
        largeTitleTextAttributes = textAttributes
        titleTextAttributes = textAttributes
    }
}
