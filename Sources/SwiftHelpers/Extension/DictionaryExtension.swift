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
    
    func safeGet(_ key: Key) -> Value? {
        if let val = dict[key] {
            return val
        }
        return nil
    }
}
