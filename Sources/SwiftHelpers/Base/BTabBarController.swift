//
//  BTabBarController.swift
//  
//
//  Created by Márk József Alexa on 2020. 10. 30..
//

import UIKit

public protocol BTabBarProtocol {
	func tabBarTitle() -> String
	func tabBarImages() -> (UIImage?, UIImage?) // (normal, selected)
}

open class BTabBarController: UITabBarController {
	public override var viewControllers: [UIViewController]? {
		didSet {
			self.setupTabTitles()
		}
	}

    static public func create(_ viewControllers: [UIViewController], tintColor: UIColor? = nil) -> BTabBarController {
		let vc = BTabBarController()
		vc.viewControllers = viewControllers
        if let tintColor = tintColor {
            vc.tabBar.tintColor = tintColor
        }
		return vc
	}

	public func setupTabTitles() {
		guard let viewControllers = viewControllers, let tabBarItems = tabBar.items else { return }
		var tmpVC: BTabBarProtocol?
		for item in tabBarItems {
			guard let itemIndex = tabBarItems.firstIndex(of: item) else { return }
			let vc = viewControllers[itemIndex]
			if let vc = vc as? BaseSplitViewController, let navVC = vc.viewControllers.first as? UINavigationController, let tab = navVC.viewControllers.first as? BTabBarProtocol {
				tmpVC = tab
			} else if let navVC = vc as? UINavigationController, let tab = navVC.viewControllers.first as? BTabBarProtocol {
				tmpVC = tab
			}
			item.title = tmpVC?.tabBarTitle()
			item.image = tmpVC?.tabBarImages().0
			item.selectedImage = tmpVC?.tabBarImages().1
		}
	}
}
