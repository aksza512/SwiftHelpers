//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2020. 10. 09..
//

import Foundation

public extension Dictionary where Key == String, Value: Any {
	mutating func safeAdd(_ value: Value?, key: Key) {
		guard let value = value else { return }
		self[key] = value
	}

    func safeGet(_ key: Key?) -> Value? {
        if let tmpKey = key, let val = self[tmpKey] {
            return val
        }
        return nil
    }

    func castToObject<T: Decodable>() -> T? {
        let json = try? JSONSerialization.data(withJSONObject: self)
        do {
            return try JSONDecoder().decode(T.self, from: json!)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
