//
//  File.swift
//
//
//  Created by Márk József Alexa on 2020. 09. 22..
//

import UIKit

typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
	let closure: UIButtonTargetClosure
	init(_ closure: @escaping UIButtonTargetClosure) {
		self.closure = closure
	}
}

var disabledColorHandle: UInt8 = 0
var highlightedColorHandle: UInt8 = 0
var selectedColorHandle: UInt8 = 0
var normalColorHandle: UInt8 = 0

public extension UIButton {

	private struct AssociatedKeys {
		static var targetClosure = "targetClosure"
	}

	private var targetClosure: UIButtonTargetClosure? {
		get {
			guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
			return closureWrapper.closure
		}
		set(newValue) {
			guard let newValue = newValue else { return }
			objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	func addTargetClosure(closure: @escaping (UIButton) -> ()) {
		targetClosure = closure
		addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
	}

	@objc func closureAction() {
		guard let targetClosure = targetClosure else { return }
		targetClosure(self)
	}

	// padding - the spacing between the Image and the Title
	func centerTitleVertically(padding: CGFloat = 12.0) {
		guard let imageViewSize = self.imageView?.frame.size, let titleLabelSize = self.titleLabel?.frame.size else { return }
		let totalHeight = imageViewSize.height + titleLabelSize.height + padding
		self.imageEdgeInsets = UIEdgeInsets(
			top: -(totalHeight - imageViewSize.height) / 2,
			left: 0.0,
			bottom: 0.0,
			right: -titleLabelSize.width
		)
		self.titleEdgeInsets = UIEdgeInsets(
			top: 0.0,
			left: -imageViewSize.width,
			bottom: -(totalHeight - titleLabelSize.height),
			right: 0.0
		)
		self.contentEdgeInsets = UIEdgeInsets(
			top: 0.0,
			left: 0.0,
			bottom: titleLabelSize.height,
			right: 0.0
		)
	}

	private func image(withColor color: UIColor) -> UIImage? {
		  let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		  UIGraphicsBeginImageContext(rect.size)
		  let context = UIGraphicsGetCurrentContext()

		  context?.setFillColor(color.cgColor)
		  context?.fill(rect)

		  let image = UIGraphicsGetImageFromCurrentImageContext()
		  UIGraphicsEndImageContext()

		  return image
	  }

	func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
		  self.setBackgroundImage(image(withColor: color), for: state)
	  }

	@IBInspectable
	var disabledColor: UIColor? {
		get {
			  if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
				  return color
			  }
			  return nil
		  }
		  set {
			  if let color = newValue {
				  self.setBackgroundColor(color, for: .disabled)
				  objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			  } else {
				  self.setBackgroundImage(nil, for: .disabled)
				  objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			  }
		  }
	  }

	@IBInspectable
		var highlightedColor: UIColor? {
			get {
				if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
					return color
				}
				return nil
			}
			set {
				if let color = newValue {
					self.setBackgroundColor(color, for: .highlighted)
					objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
				} else {
					self.setBackgroundImage(nil, for: .highlighted)
					objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
				}
			}
		}

	@IBInspectable
	  var selectedColor: UIColor? {
		  get {
			  if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
				  return color
			  }
			  return nil
		  }
		  set {
			  if let color = newValue {
				  self.setBackgroundColor(color, for: .selected)
				  objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			  } else {
				  self.setBackgroundImage(nil, for: .selected)
				  objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			  }
		  }
	  }

	@IBInspectable
	  var normalColor: UIColor? {
		  get {
			  if let color = objc_getAssociatedObject(self, &normalColorHandle) as? UIColor {
				  return color
			  }
			  return nil
		  }
		  set {
			  if let color = newValue {
				  self.setBackgroundColor(color, for: .normal)
				  objc_setAssociatedObject(self, &normalColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			  } else {
				  self.setBackgroundImage(nil, for: .normal)
				  objc_setAssociatedObject(self, &normalColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			  }
		  }
	  }

	private var states: [UIControl.State] {
		return [.normal, .selected, .highlighted, .disabled]
	}

	func setTitleForAllStates(_ title: String) {
		states.forEach { self.setTitle(title, for: $0) }
	}

	func setImageForAllStates(_ image: UIImage) {
		states.forEach { self.setImage(image, for: $0) }
	}

	func setTitleColorForAllStates(_ color: UIColor) {
		states.forEach { self.setTitleColor(color, for: $0) }
	}
}
