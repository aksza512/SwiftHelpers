//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 11. 16..
//

import UIKit

public extension UIImage {
	func rotate(radians: Float) -> UIImage? {
		 var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
		 // Trim off the extremely small float value to prevent core graphics from rounding it up
		 newSize.width = floor(newSize.width)
		 newSize.height = floor(newSize.height)

		 UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
		 let context = UIGraphicsGetCurrentContext()!

		 // Move origin to middle
		 context.translateBy(x: newSize.width/2, y: newSize.height/2)
		 // Rotate around middle
		 context.rotate(by: CGFloat(radians))
		 // Draw the image at its center
		 self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

		 let newImage = UIGraphicsGetImageFromCurrentImageContext()
		 UIGraphicsEndImageContext()

		 return newImage
	 }

	func resizeImage(targetSize: CGSize) -> UIImage {
		let size = self.size
		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height
		let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage!
	}
}
