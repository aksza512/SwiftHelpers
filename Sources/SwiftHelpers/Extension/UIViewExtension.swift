//
//  UIViewExtension.swift
//  SwiftHelpers
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

let defaultAnimationDuration = 0.3
let emptyViewTag = 9876

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
	
	func showEmptyView(_ emptyView: EmptyView) {
		if !self.subviews.contains(emptyView) {
			emptyView.tag = emptyViewTag
			addSubview(emptyView)
			emptyView.translatesAutoresizingMaskIntoConstraints = false
			emptyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
			emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
			emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
			if (self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .regular) {
				emptyView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 10.0).isActive = true
				emptyView.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: 10.0).isActive = true
				emptyView.widthAnchor.constraint(equalToConstant: 320.0).isActive = true
			}
			else {
				emptyView.translatesAutoresizingMaskIntoConstraints = true
				emptyView.frame = self.bounds
				emptyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
			}
		}
	}
	
	func hideEmpty() {
		self.viewWithTag(emptyViewTag)?.removeFromSuperview()
	}
	
	func hide() {
		alpha = 0.0
	}

	func show() {
		alpha = 1.0
	}

    var left: CGFloat {
        set (left) {
			frame = CGRect(x: left, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
        get {
			frame.origin.x
		}
    }


    var right: CGFloat {
        set (right) {
			frame = CGRect(x: right - self.width, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
        get {
			frame.origin.x + self.width
		}
    }

    var width: CGFloat {
        set (width) {
			frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
        }
        get {
			frame.size.width
		}
    }

    var height: CGFloat {
        set (height) {
			frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        }
        get {
			frame.size.height
		}
    }

    var centerX: CGFloat {
        set (centerX) {
			frame = CGRect(x: centerX - (width / 2), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
        get {
			width / 2
		}
    }

    var centerY: CGFloat {
        set (centerY) {
			frame = CGRect(x: frame.origin.x, y: centerY - (height / 2), width: frame.size.width, height: frame.size.height)
        }
        get {
			height / 2
		}
    }
}
