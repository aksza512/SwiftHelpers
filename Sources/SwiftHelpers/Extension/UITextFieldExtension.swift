//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 22..
//

import UIKit

public extension UITextField {
	var hasValidEmail: Bool {
		return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: String.CompareOptions.regularExpression, range: nil, locale: nil) != nil
	}

	func setPlaceHolderTextColor(_ color: UIColor) {
		guard let holder = placeholder, !holder.isEmpty else { return }
		attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
	}

	func clear() {
		text = ""
		attributedText = NSAttributedString(string: "")
	}
}
