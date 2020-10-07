//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 22..
//

import UIKit

public extension UIViewController {
	func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 17.0, weight: .regular), toastColor: UIColor = .white, toastBackground: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)) {
		let toastLabel = UILabel()
		toastLabel.textColor = toastColor
		toastLabel.font = font
		toastLabel.textAlignment = .center
		toastLabel.text = message
		toastLabel.alpha = 0.0
		toastLabel.layer.cornerRadius = 8
		toastLabel.backgroundColor = toastBackground
		toastLabel.clipsToBounds  =  true
		let toastWidth: CGFloat = toastLabel.intrinsicContentSize.width + 24
		let toastHeight: CGFloat = 44
		toastLabel.frame = CGRect(x: self.view.frame.width / 2 - (toastWidth / 2), y: self.view.frame.height - (toastHeight * 3), width: toastWidth, height: toastHeight)
		self.view.addSubview(toastLabel)
		UIView.animate(withDuration: 1.5, delay: 0.1, options: .autoreverse, animations: {
			toastLabel.alpha = 1.2
		}) { _ in
			toastLabel.removeFromSuperview()
		}
	}

	var isVisible: Bool {
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

	static func topMostViewController() -> UIViewController? {
	   if #available(iOS 13.0, *) {
		   let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		   return keyWindow?.rootViewController?.topMostViewController()
	   }
	   return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
	}

	func topMostViewController() -> UIViewController? {
	   if let navigationController = self as? UINavigationController {
		   return navigationController.topViewController?.topMostViewController()
	   }
	   else if let tabBarController = self as? UITabBarController {
		   if let selectedViewController = tabBarController.selectedViewController {
			   return selectedViewController.topMostViewController()
		   }
		   return tabBarController.topMostViewController()
	   }
	   else if let presentedViewController = self.presentedViewController {
		   return presentedViewController.topMostViewController()
	   }
	   else {
		   return self
	   }
	}
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
public extension UIViewController {
	private struct Preview: UIViewControllerRepresentable {
		let viewController: UIViewController

		func makeUIViewController(context: Context) -> UIViewController {
			return viewController
		}

		func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		}
	}

	func toPreview() -> some View {
		Preview(viewController: self)
	}
}
#endif

