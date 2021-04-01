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
            self.layer.masksToBounds = false
        }
        get {
            return self.layer.shadowRadius
        }
    }
	
    @IBInspectable var shadowOpacity: Float {
        set (opacity) {
            self.layer.shadowOpacity = opacity
            self.layer.masksToBounds = false
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

	func fadeOut(_ completion: (() -> Void)? = nil ) {
		UIView.animate(withDuration: defaultAnimationDuration) {
			self.alpha = 0.0
		} completion: { (success) in
			if let completion = completion { completion() }
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
	
	var bottom: CGFloat {
		set (bottom) {
			frame = CGRect(x: frame.origin.x, y: bottom - frame.size.height, width: frame.size.width, height: frame.size.height)
		}
		get {
			frame.origin.y + frame.size.height
		}
	}

	var top: CGFloat {
		set (top) {
			frame = CGRect(x: frame.origin.x, y: top, width: frame.size.width, height: frame.size.height)
		}
		get {
			frame.origin.y
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
			var center = self.center
			center.y = centerY
			self.center = center
        }
        get {
			self.center.y
		}
    }

	func addBottomRoundedEdge(desiredCurve: CGFloat?) {
		let offset: CGFloat = self.frame.width / desiredCurve!
		let bounds: CGRect = self.bounds
		let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
		let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
		let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
		let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
		rectPath.append(ovalPath)
		let maskLayer: CAShapeLayer = CAShapeLayer()
		maskLayer.frame = bounds
		maskLayer.path = rectPath.cgPath
		self.layer.mask = maskLayer
	}

	func shake() {
		self.transform = CGAffineTransform(translationX: 20, y: 0)
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			self.transform = CGAffineTransform.identity
		}, completion: nil)
	}
	
	func shake(duration: TimeInterval, delay: TimeInterval, delta: CGFloat, _ completion: (() -> Void)?) {
		CATransaction.begin()
		CATransaction.setCompletionBlock {
			if let completion = completion { completion() }
		}
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		animation.timingFunction = CAMediaTimingFunction(name: .linear)
		animation.duration = duration
		animation.beginTime = CACurrentMediaTime() + delay
		animation.values = [ (0), (-delta), (delta), (-delta), (delta), (-(delta / 2.0)), ((delta / 2.0)), (-(delta / 4.0)), ((delta / 4.0)), 0 ]
		self.layer.add(animation, forKey: "shakeAnimation")
		CATransaction.commit()
	}

	func removeAllSubviews() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
	}

	func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		 let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		 let mask = CAShapeLayer()
		 mask.path = path.cgPath
		 layer.mask = mask
	 }

	private func degreesToRadians(_ x: CGFloat) -> CGFloat {
		return .pi * x / 180.0
	}

	func stopWiggle() {
		self.layer.removeAllAnimations()
		self.transform = .identity
	}

	func startWiggle(
		duration: Double = 0.25,
		displacement: CGFloat = 1.0,
		degreesRotation: CGFloat = 2.0
		) {
		let negativeDisplacement = -1.0 * displacement
		let position = CAKeyframeAnimation.init(keyPath: "position")
		position.beginTime = 0.8
		position.duration = duration
		position.values = [
			NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement)),
			NSValue(cgPoint: CGPoint(x: 0, y: 0)),
			NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: 0)),
			NSValue(cgPoint: CGPoint(x: 0, y: negativeDisplacement)),
			NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement))
		]
		position.calculationMode = CAAnimationCalculationMode(rawValue: "linear")
		position.isRemovedOnCompletion = false
		position.repeatCount = Float.greatestFiniteMagnitude
		position.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))
		position.isAdditive = true

		let transform = CAKeyframeAnimation.init(keyPath: "transform")
		transform.beginTime = 2.6
		transform.duration = duration
		transform.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
		transform.values = [
			degreesToRadians(-1.0 * degreesRotation),
			degreesToRadians(degreesRotation),
			degreesToRadians(-1.0 * degreesRotation)
		]
		transform.calculationMode = CAAnimationCalculationMode(rawValue: "linear")
		transform.isRemovedOnCompletion = false
		transform.repeatCount = Float.greatestFiniteMagnitude
		transform.isAdditive = true
		transform.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))
		self.layer.add(position, forKey: nil)
		self.layer.add(transform, forKey: nil)
	}

	func asImage() -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		return renderer.image { rendererContext in
			layer.render(in: rendererContext.cgContext)
		}
	}
	
	func addSubview(top constraints: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat, view: UIView) {
		addSubview(view)
		view.topAnchor.constraint(equalTo: self.topAnchor, constant: top).isActive = true
		view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: right).isActive = true
		view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom).isActive = true
		view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: left).isActive = true
	}
	
	func setAnchorPoint(_ point: CGPoint) {
		var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
		var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

		newPoint = newPoint.applying(transform)
		oldPoint = oldPoint.applying(transform)

		var position = layer.position

		position.x -= oldPoint.x
		position.x += newPoint.x

		position.y -= oldPoint.y
		position.y += newPoint.y

		layer.position = position
		layer.anchorPoint = point
	}
}
