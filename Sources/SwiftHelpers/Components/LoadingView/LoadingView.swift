//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2021. 03. 05..
//

import UIKit

open class LoadingView: BView {
	@IBOutlet private var contentView: UIView!

	open override func initInternals() {
		super.initInternals()
		createContentView()
	}

	func createContentView() {
		if #available(iOS 13.0, *) {
			let indicator = UIActivityIndicatorView(style: .medium)
			indicator.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(indicator)
			indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
			indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
			indicator.startAnimating()
		}
	}
}

