//
//  EncodableExtension.swift
//  
//
//  Created by Márk József Alexa on 2020. 05. 27..
//

import Foundation

public extension Encodable {
	var dictionary: [String: Any]? {
		guard let data = try? JSONEncoder().encode(self) else { return nil }
		return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
	}
}

public extension Decodable {
	static func fromJSON<T:Decodable>(_ fileName: String, fileExtension: String="json", bundle: Bundle = .main) throws -> T {
		guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
			throw NSError(domain: NSURLErrorDomain, code: NSURLErrorResourceUnavailable)
		}
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode(T.self, from: data)
	}
}

public protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }

public extension CaseIterableDefaultsLast {
	init(from decoder: Decoder) throws {
		self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
	}
}
