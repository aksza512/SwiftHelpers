//
//  File.swift
//  
//
//  Created by Alexa Mark on 2021. 12. 08..
//

import Foundation

public extension UserDefaults {
    func setEncodable<T: Encodable>(_ encodable: T, for key: String) throws {
        let data = try PropertyListEncoder().encode(encodable)
        self.set(data, forKey: key)
    }

    func getDecodable<T: Decodable>(for key: String) -> T? {
        guard
            self.object(forKey: key) != nil,
            let data = self.value(forKey: key) as? Data
        else {
            return nil
        }

        let obj = try? PropertyListDecoder().decode(T.self, from: data)
        return obj
    }
}
