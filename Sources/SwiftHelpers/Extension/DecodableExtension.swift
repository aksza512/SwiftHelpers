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
