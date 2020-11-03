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
}
