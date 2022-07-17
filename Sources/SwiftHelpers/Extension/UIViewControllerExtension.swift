//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 22..
//

import UIKit

public extension UIViewController {
	func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 17.0, weight: .regular), toastColor: UIColor = .white, toastBackground: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)) {
		let toastLabel = UILabel()
		toastLabel.textColor = toastColor
		toastLabel.font = font
		toastLabel.textAlignment = .center
		toastLabel.text = message
		toastLabel.clipsToBounds  =  true
		toastLabel.numberOfLines = 0
		
		let bgrView = UIView()
		bgrView.cornerRadius = 10
		bgrView.backgroundColor = toastBackground
		bgrView.clipsToBounds  =  true
		bgrView.alpha = 0.0
		bgrView.translatesAutoresizingMaskIntoConstraints = false
		toastLabel.translatesAutoresizingMaskIntoConstraints = false

		bgrView.addSubview(toastLabel)
		self.view.addSubview(bgrView)

		toastLabel.sizeToFit()
		let toastWidth: CGFloat = toastLabel.width
		let labelWidth = min(toastWidth, self.view.frame.width - 50.0)

		toastLabel.leftAnchor.constraint(equalTo: bgrView.leftAnchor, constant: 10).isActive = true
		toastLabel.rightAnchor.constraint(equalTo: bgrView.rightAnchor, constant: -10).isActive = true
		toastLabel.bottomAnchor.constraint(equalTo: bgrView.bottomAnchor, constant: -10).isActive = true
		toastLabel.topAnchor.constraint(equalTo: bgrView.topAnchor, constant: 10).isActive = true

		bgrView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		bgrView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 44.0).isActive = true
		bgrView.widthAnchor.constraint(equalToConstant: labelWidth + 30.0).isActive = true
		
		UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseIn, animations: {
			bgrView.alpha = 4.0
		}) { _ in
			UIView.animate(withDuration: 0.8, delay: 3.0, options: .curveEaseOut, animations: {
				bgrView.alpha = 0.0
			}) { _ in
				bgrView.removeFromSuperview()
			}
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
       let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
       return keyWindow?.rootViewController?.topMostViewController()
	}

    static func topMostViewControllerWithTabbar() -> UIViewController? {
       let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
       return keyWindow?.rootViewController?.topMostViewControllerWithTabbar()
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
    
    func topMostViewControllerWithTabbar() -> UIViewController? {
       if let navigationController = self as? UINavigationController {
           return navigationController.topViewController?.topMostViewController()
       }
       else if let tabBarController = self as? UITabBarController {
           return tabBarController
       }
       else if let presentedViewController = self.presentedViewController {
           return presentedViewController.topMostViewController()
       }
       else {
           return self
       }
    }

	func add(_ child: UIViewController?, frame: CGRect? = nil, containerView: UIView? = nil, animate: Bool = false) {
		guard let child = child else { return }
		 addChild(child)
		 if let frame = frame {
			 child.view.frame = frame
		 }
		 view.addSubview(child.view)
		if animate {
			child.view.hide()
			UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
				child.view.alpha = 1.0
			} completion: { success in
				
			}
		}
		if let containerView = containerView {
			child.view.translatesAutoresizingMaskIntoConstraints = false
			child.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
			child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
			child.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
			child.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
		}
		child.didMove(toParent: self)
	 }

	 func remove() {
		 willMove(toParent: nil)
		 view.removeFromSuperview()
		 removeFromParent()
	 }

	func remove(_ completion: (() -> Void)? = nil) {
		UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
			self.view.alpha = 0.0
		} completion: { success in
			self.willMove(toParent: nil)
			self.view.removeFromSuperview()
			self.removeFromParent()
			completion?()
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

