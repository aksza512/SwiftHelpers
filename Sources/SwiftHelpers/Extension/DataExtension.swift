//
//  File.swift
//  
//
//  Created by Alexa Márk on 2021. 04. 07..
//

import Foundation

public extension Data {
	var format: String {
		let array = [UInt8](self)
		let ext: String
		switch (array[0]) {
		case 0xFF:
			ext = "jpg"
		case 0x89:
			ext = "png"
		case 0x47:
			ext = "gif"
		case 0x49, 0x4D :
			ext = "tiff"
		default:
			ext = "unknown"
		}
		return ext
	}
	
	func hexString() -> String {
		return self.map { String(format: "%.2hhx", $0) }.joined()
	}
	
	/// Append string to Data
	///
	/// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
	///
	/// - parameter string:       The string to be added to the `Data`.
	mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
		if let data = string.data(using: encoding) {
			append(data)
		}
	}

	var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
		  guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
				let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
				let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
		  return prettyPrintedString
	  }
}
