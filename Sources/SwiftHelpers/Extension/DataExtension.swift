//
//  File.swift
//  
//
//  Created by Alexa Márk on 2021. 04. 07..
//

import Foundation

public extension Data {
	func hexString() -> String {
		return self.map { String(format: "%.2hhx", $0) }.joined()
	}
}
