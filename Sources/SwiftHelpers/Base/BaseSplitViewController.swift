//
//  dsaf.swift
//  reapp
//
//  Created by Márk József Alexa on 2020. 10. 26..
//

import UIKit

@objcMembers
public class BaseSplitViewController: UISplitViewController {

	static public func splitViewController(masterViewController: UIViewController) -> BaseSplitViewController {
		let splitViewController = BaseSplitViewController()
		splitViewController.viewControllers = [masterViewController]
		splitViewController.minimumPrimaryColumnWidth = 350.0
		splitViewController.maximumPrimaryColumnWidth = 350.0
		splitViewController.edgesForExtendedLayout = .all
		splitViewController.extendedLayoutIncludesOpaqueBars = true
		splitViewController.preferredDisplayMode = .allVisible
		return splitViewController
	}

}
