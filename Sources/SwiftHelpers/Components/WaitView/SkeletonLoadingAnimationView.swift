//
//  SkeletonLoadingAnimationView.swift
//  SwiftHelpers
//
//  Created by Márk József Alexa on 2020. 08. 17..
//

import UIKit

class SkeletonLoadingAnimationView: BView {
	
	override func initInternals() {
		super.initInternals()
		self.layer.mask?.removeAllAnimations()
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [backgroundColor?.withAlphaComponent(0.0).cgColor ?? UIColor.white.cgColor, UIColor.red.cgColor, backgroundColor?.withAlphaComponent(0.0).cgColor ?? UIColor.white.cgColor]
		gradientLayer.locations = [0, 0.5, 1]
		gradientLayer.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
		let angle = 90 * CGFloat.pi / 180
		gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
		self.layer.mask = gradientLayer
		//		topSmallRectView.layer.insertSublayer(gradientLayer, at: 0)
		//animation
		let animation = CABasicAnimation(keyPath: "transform.translation.x")
		animation.duration = 2
		animation.fromValue = -gradientLayer.frame.width - 50
		animation.toValue = gradientLayer.frame.width + 50
		animation.repeatCount = Float.infinity
		animation.isRemovedOnCompletion = false
		gradientLayer.add(animation, forKey: "skeleton")
	}
	
}
