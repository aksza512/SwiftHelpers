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
}
