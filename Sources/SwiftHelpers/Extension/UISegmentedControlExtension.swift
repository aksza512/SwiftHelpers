//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2021. 01. 07..
//

import UIKit

public extension UISegmentedControl {
	func replaceSegments(segments: Array<String>) {
		self.removeAllSegments()
		for segment in segments {
			self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
		}
	}
}
