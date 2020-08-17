//
//  UIViewExtension.swift
//  SwiftHelpers
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

let defaultAnimationDuration = 0.3

public extension UIView {
	// Border
    @IBInspectable var cornerRadius: CGFloat {
        set (radius) {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = radius > 0
        }
        get {
            return self.layer.cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set (borderWidth) {
            self.layer.borderWidth = borderWidth
        }
        get {
            return self.layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set (color) {
            self.layer.borderColor = color?.cgColor
        }
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
	
	// Shadow
    @IBInspectable var shadowRadius: CGFloat {
        set (radius) {
            self.layer.shadowRadius = radius
            self.layer.masksToBounds = radius > 0
        }
        get {
            return self.layer.shadowRadius
        }
    }
	
    @IBInspectable var shadowOpacity: Float {
        set (opacity) {
            self.layer.shadowOpacity = opacity
            self.layer.masksToBounds = opacity > 0
        }
        get {
            return self.layer.shadowOpacity
        }
    }

    @IBInspectable var shadowColor: UIColor {
        set (color) {
			self.layer.shadowColor = color.cgColor
        }
        get {
			return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set (offset) {
            self.layer.shadowOffset = offset
        }
        get {
            return self.layer.shadowOffset
        }
    }

	func fadeIn() {
		UIView.animate(withDuration: defaultAnimationDuration) {
			self.alpha = 1.0
		}
	}

	func fadeOut() {
		UIView.animate(withDuration: defaultAnimationDuration) {
			self.alpha = 0.0
		}
	}
}
