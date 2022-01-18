//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 26..
//

import Foundation
import UIKit

public extension String {
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }

    static func getDecodedJwtBodyString(tokenstr: String) -> (String?, Data?) {
        let segments = tokenstr.components(separatedBy: ".")
        var base64String = segments[1]
        let requiredLength = Int(4 * ceil(Float(base64String.count) / 4.0))
        let nbrPaddings = requiredLength - base64String.count
        if nbrPaddings > 0 {
            let padding = String().padding(toLength: nbrPaddings, withPad: "=", startingAt: 0)
            base64String = base64String.appending(padding)
        }
        base64String = base64String.replacingOccurrences(of: "-", with: "+")
        base64String = base64String.replacingOccurrences(of: "_", with: "/")
        let decodedData = Data(base64Encoded: base64String, options: Data.Base64DecodingOptions(rawValue: UInt(0)))
        let base64Decoded: String = String(data: decodedData! as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        return (base64Decoded, decodedData)
    }

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
    
    
    enum TrimmingOptions {
        case all
        case leading
        case trailing
        case leadingAndTrailing
    }
    
    func trimming(spaces: TrimmingOptions, using characterSet: CharacterSet = .whitespacesAndNewlines) ->  String {
        switch spaces {
        case .all: return trimmingAllSpaces(using: characterSet)
        case .leading: return trimingLeadingSpaces(using: characterSet)
        case .trailing: return trimingTrailingSpaces(using: characterSet)
        case .leadingAndTrailing:  return trimmingLeadingAndTrailingSpaces(using: characterSet)
        }
    }
    
    private func trimingLeadingSpaces(using characterSet: CharacterSet) -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }

        return String(self[index...])
    }
    
    private func trimingTrailingSpaces(using characterSet: CharacterSet) -> String {
        guard let index = lastIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }

        return String(self[...index])
    }
    
    private func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet) -> String {
        return trimmingCharacters(in: characterSet)
    }
    
    private func trimmingAllSpaces(using characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined()
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
