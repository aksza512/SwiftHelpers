//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2022. 02. 07..
//

import Foundation

public extension Decodable {
    static func decode(from dictionary: [String: Any]) -> Self? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let obj = try decoder.decode(Self.self, from: data)
            return obj
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

@propertyWrapper
public struct StringForcible: Codable {
    
    public var wrappedValue: String?
    
    enum CodingKeys: CodingKey {}
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            wrappedValue = string
        } else if let integer = try? container.decode(Int.self) {
            wrappedValue = "\(integer)"
        } else if let double = try? container.decode(Double.self) {
            wrappedValue = "\(double)"
        } else if container.decodeNil() {
            wrappedValue = nil
        }
        else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: container.codingPath, debugDescription: "Could not decode incoming value to String. It is not a type of String, Int or Double."))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
    
    public init() {
        self.wrappedValue = nil
    }
    
}
