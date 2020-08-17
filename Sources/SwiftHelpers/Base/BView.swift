//
//  BaseView.swift
//  SwiftHelpers
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

public class BView: UIView {
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.initInternals()
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		self.initInternals()
	}
	
	required init?(coder aDecoder: NSCoder) {
	   super.init(coder: aDecoder)
		self.initInternals()
	}
	
	func initInternals() {
		
	}
}
