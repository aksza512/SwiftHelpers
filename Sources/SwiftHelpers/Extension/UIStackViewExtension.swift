//
//  UIStackViewExtension.swift
//  ingatlancom
//
//  Created by Alexa Márk on 2021. 02. 07..
//  Copyright © 2021. Alexa Mark. All rights reserved.
//

import UIKit

public extension UIStackView {
	func setView(_ views: [UIView], gone: Bool, animated: Bool, duration: Double = 0.3) {
		self.setViews(views, gone: gone, animated: animated, completion: nil)
	}

	func setViews(_ views: [UIView], gone: Bool, animated: Bool, duration: Double = 0.3, completion: (() -> ())?) {
		if animated {
			if gone {
				UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
					for view in views {
						view.alpha = 0
					}
				}, completion: { fin in
					if !fin { return }
					for view in views {
						view.isHidden = true
					}
					UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
						self.superview!.layoutIfNeeded()
					}, completion: { fin in
						if let completion = completion {
							completion()
						}
					})
				})
			} else {
				for view in views {
					view.isHidden = false
					view.alpha = 0
				}
				UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
					self.superview!.layoutIfNeeded()
				}, completion: { fin in
					if !fin {
						if let completion = completion {
							completion()
						}
						return
					}
					UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
						for view in views {
							view.alpha = 1
						}
					}, completion: { fin in
						if let completion = completion {
							completion()
						}
					})
				})
			}
		} else {
			for view in views {
				view.alpha = gone ? 0 : 1
				view.isHidden = gone ? true : false
			}
		}
	}
}
