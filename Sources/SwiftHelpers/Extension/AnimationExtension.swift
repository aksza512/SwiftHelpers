//
//  File.swift
//  
//
//  Created by Alexa Márk on 2022. 04. 01..
//

import SwiftUI

public extension Animation {
    static let fast: Animation = {
        Animation.easeOut(duration: 0.2)
    }()
}
