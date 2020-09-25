//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 22..
//

import UIKit

public extension UIViewController {
	func showToast(message : String, font: UIFont, toastColor: UIColor = UIColor.white, toastBackground: UIColor = UIColor.black) {
		let toastLabel = UILabel()
		toastLabel.textColor = toastColor
		toastLabel.font = font
		toastLabel.textAlignment = .center
		toastLabel.text = message
		toastLabel.alpha = 0.0
		toastLabel.layer.cornerRadius = 6
		toastLabel.backgroundColor = toastBackground
		toastLabel.clipsToBounds  =  true
		let toastWidth: CGFloat = toastLabel.intrinsicContentSize.width + 16
		let toastHeight: CGFloat = 32
		toastLabel.frame = CGRect(x: self.view.frame.width / 2 - (toastWidth / 2), y: self.view.frame.height - (toastHeight * 3), width: toastWidth, height: toastHeight)
		self.view.addSubview(toastLabel)
		UIView.animate(withDuration: 1.5, delay: 0.25, options: .autoreverse, animations: {
			toastLabel.alpha = 1.0
		}) { _ in
			toastLabel.removeFromSuperview()
		}
	}

	var isVisible: Bool {
		// http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
		return isViewLoaded && view.window != nil
	}

	func hideKeyboardOnTap() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
	}

	@objc func hideKeyboard() {
		self.view.endEditing(true)
	}
}
