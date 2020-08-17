//
//  UIViewExtension.swift
//  SwiftHelpers
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

let defaultAnimationDuration = 0.3

public extension UIView {
	func fadeIn() {
		UIView.animate(withDuration: defaultAnimationDuration) {
			self.alpha = 1.0
		}
	}
}
