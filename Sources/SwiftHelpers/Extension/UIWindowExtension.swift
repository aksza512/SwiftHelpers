//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 21..
//

import Foundation
import UIKit

public extension UIWindow {

	func switchRootViewController(_ viewController: UIViewController, animated: Bool = true, duration: TimeInterval = 0.3, options: UIView.AnimationOptions = .transitionCrossDissolve, completion: (() -> Void)? = nil) {
		clearTransitions()
		guard animated else {
			rootViewController = viewController
			completion?()
			return
		}
		UIView.transition(with: self, duration: duration, options: options, animations: {
			let oldState = UIView.areAnimationsEnabled
			UIView.setAnimationsEnabled(false)
			self.rootViewController = viewController
			UIView.setAnimationsEnabled(oldState)
			// swiftlint:disable:next multiple_closures_with_trailing_closure
		}) { _ in
			completion?()
		}
	}

	func clearTransitions() {
		if let transitionViewClass = NSClassFromString("UITransitionView") {
			for subview in subviews where subview.isKind(of: transitionViewClass) {
				subview.removeFromSuperview()
			}
		}
	}

//	func visibleViewController() -> UIViewController? {
//		if let rootViewController: UIViewController = self.rootViewController {
//			return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
//		}
//		return nil
//	}
//
//	static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
//		if let navigationController = vc as? UINavigationController,
//			let visibleController = navigationController.visibleViewController  {
//			return UIWindow.getVisibleViewControllerFrom( vc: visibleController )
//		} else if let tabBarController = vc as? UITabBarController,
//			let selectedTabController = tabBarController.selectedViewController {
//			return UIWindow.getVisibleViewControllerFrom(vc: selectedTabController )
//		} else {
//			if let presentedViewController = vc.presentedViewController {
//				return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
//			} else {
//				return vc
//			}
//		}
//	}
}
