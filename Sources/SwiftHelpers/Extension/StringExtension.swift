//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 26..
//

import Foundation
import UIKit
import CryptoKit

public extension StringProtocol {
    subscript(offset: Int) -> String? {
        guard self.count > offset else { return nil }
        return String(self[index(startIndex, offsetBy: offset)])
    }
}

public extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func convertToArray() -> [Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    var javaScriptEscapedString: String {
        // Because JSON is not a subset of JavaScript, the LINE_SEPARATOR and PARAGRAPH_SEPARATOR unicode
        // characters embedded in (valid) JSON will cause the webview's JavaScript parser to error. So we
        // must encode them first. See here: http://timelessrepo.com/json-isnt-a-javascript-subset
        // Also here: http://media.giphy.com/media/wloGlwOXKijy8/giphy.gif
        let str = self.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
            .replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        // Because escaping JavaScript is a non-trivial task (https://github.com/johnezang/JSONKit/blob/master/JSONKit.m#L1423)
        // we proceed to hax instead:
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode([str])
            let encodedString = String(decoding: data, as: UTF8.self)
            return String(encodedString.dropLast().dropFirst())
        } catch {
            return self
        }
    }
    
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && !hasNumbers
    }
    
    var isDecimalDigits: Bool {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    var sha512: String {
        let hashed = SHA512.hash(data: Data(self.utf8))
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    func isValidEmailAddress() -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = self.range(
            of: emailPattern,
            options: .regularExpression
        )
        return result != nil
    }


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
    
    func changeSubstring(findString: String, toString: String) -> String {
        self.replacingOccurrences(of: findString, with: toString)
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
