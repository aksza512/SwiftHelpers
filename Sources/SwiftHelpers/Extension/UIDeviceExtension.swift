//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 22..
//

import UIKit

public extension UIDevice {
	static func isIpad() -> Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}

	static func isPhone() -> Bool {
		return UIDevice.current.userInterfaceIdiom == .phone
	}
}
