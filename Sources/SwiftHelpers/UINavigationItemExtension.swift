//
//  File.swift
//  
//
//  Created by Alexa Márk on 2019. 11. 07..
//

import UIKit

public extension UINavigationItem {
    func addLeftItem(_ image: UIImage, tintColor: UIColor, target: Any, selector: Selector) {
        let item = UIBarButtonItem(image: image, style: .plain, target: target, action: selector)
        item.tintColor = tintColor
        leftBarButtonItem = item
    }
}
