//
//  BView.swift
//  SwiftHelpers
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

open class BView: UIView {

//	init() {
//		super.init(frame: UIScreen.main.bounds);
//		self.initInternals()
//	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.initInternals()
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		self.initInternals()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	open func initInternals() {
		
	}
}
