//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 10. 30..
//

import UIKit

open class BNavigationViewController: UINavigationController {

	public override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
	}

	public init(color: UIColor?, rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		navigationBar.tintColor = color
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
