//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 09. 22..
//

import UIKit

public extension Bundle {
	func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
		guard let url = self.url(forResource: file, withExtension: nil) else {
			fatalError("Failed to locate \(file) in bundle.")
		}
		guard let data = try? Data(contentsOf: url) else {
			fatalError("Failed to load \(file) from bundle.")
		}
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = dateDecodingStrategy
		decoder.keyDecodingStrategy = keyDecodingStrategy
		do {
			return try decoder.decode(T.self, from: data)
		} catch DecodingError.keyNotFound(let key, let context) {
			fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
		} catch DecodingError.typeMismatch(_, let context) {
			fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
		} catch DecodingError.valueNotFound(let type, let context) {
			fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
		} catch DecodingError.dataCorrupted(_) {
			fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
		} catch {
			fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
		}
	}

    func decodeToDict(fromFile: String) -> [String: Any]? {
        guard let url = self.url(forResource: fromFile, withExtension: nil) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
	
	func loadFirst(fromNib: String) -> Any? {
		return loadNibNamed(fromNib, owner: nil, options: nil)?.first
	}
}
