//
//  File.swift
//  
//
//  Created by Alexa Márk on 2022. 09. 29..
//

import Foundation

public extension Int {
    var digitCount: Int {
        get {
            return numberOfDigits(in: self)
        }
    }

    private func numberOfDigits(in number: Int) -> Int {
        if number < 10 && number >= 0 || number > -10 && number < 0 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number/10)
        }
    }
}
