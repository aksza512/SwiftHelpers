//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 26..
//

import Foundation
import UIKit

public extension String {
	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
		return boundingBox.width;
	}

	// MARK: Get remove all characters exept numbers
	var detectedPhoneNumbers: [PhoneNumber] { PhoneNumber.extractAll(from: self) }
	var detectedFirstPhoneNumber: PhoneNumber? { PhoneNumber.first(in: self) }

   func onlyDigits() -> String {
	   let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
	   return String(String.UnicodeScalarView(filtredUnicodeScalars))
   }

	func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return range(of: string, options: .caseInsensitive) != nil
		}
		return range(of: string) != nil
	}
	
	var isValidEmail: Bool {
		   let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		   let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		   return emailTest.evaluate(with: self)
	   }
}

public extension NSMutableAttributedString {

	func bold(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {

		let attributes:[NSAttributedString.Key : Any] = [
			.font : UIFont.boldSystemFont(ofSize: fontSize),
		]

		self.append(NSAttributedString(string: value, attributes:attributes))
		return self
	}

	func font(_ value: String, font: UIFont) -> NSMutableAttributedString {

		let attributes:[NSAttributedString.Key : Any] = [
			.font : font,
		]

		self.append(NSAttributedString(string: value, attributes:attributes))
		return self
	}

	func bold(_ value: String, fontSize: CGFloat, color: UIColor?) -> NSMutableAttributedString {

		let attributes:[NSAttributedString.Key : Any] = [
			.font : UIFont.boldSystemFont(ofSize: fontSize),
			.foregroundColor : color ?? .black
		]

		self.append(NSAttributedString(string: value, attributes:attributes))
		return self
	}

	func normal(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {

		let attributes:[NSAttributedString.Key : Any] = [
			.font : UIFont.systemFont(ofSize: fontSize),
		]

		self.append(NSAttributedString(string: value, attributes:attributes))
		return self
	}

	func underlined(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {

		let attributes:[NSAttributedString.Key : Any] = [
			.font :  UIFont.systemFont(ofSize: fontSize),
			.underlineStyle : NSUnderlineStyle.single.rawValue

		]

		self.append(NSAttributedString(string: value, attributes:attributes))
		return self
	}
}
