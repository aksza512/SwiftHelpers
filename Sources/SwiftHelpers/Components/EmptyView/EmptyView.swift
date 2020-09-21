//
//  EmptyView.swift
//  
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

open class EmptyView: BView {
	@IBOutlet public var contentView: UIView!
	
	public override func initInternals() {
		super.initInternals()
	}
	
	public func showEmptyView() {
		self.fadeIn()
	}
	
	public func hideEmptyView() {
		self.fadeOut()
	}
}
