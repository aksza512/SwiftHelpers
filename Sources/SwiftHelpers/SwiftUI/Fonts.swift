//
//  Fonts.swift
//  wordpuzzle
//
//  Created by Alexa Mark on 2021. 12. 05..
//

import SwiftUI

public extension Font {
    // MARK: Heading
    static let headings1 = Font.system(size: 40, weight: .bold)
    static let headings2 = Font.system(size: 32, weight: .bold)
    static let headings3 = Font.system(size: 24, weight: .bold)
    static let headings4 = Font.system(size: 20, weight: .bold)
    static let headings5 = Font.system(size: 16, weight: .bold)
    static let headings6 = Font.system(size: 14, weight: .bold)
    static let headings7 = Font.system(size: 12, weight: .bold)

    // MARK: Lead
    static let lead1 = Font.system(size: 40)
    static let lead2 = Font.system(size: 32)
    static let lead3 = Font.system(size: 24)
    static let lead4 = Font.system(size: 20)

    // MARK: BodyFont
    static let body1 = Font.system(size: 16)
    static let body2 = Font.system(size: 14)
    static let body3 = Font.system(size: 12)
}

public extension UIFont {
//    static let headings4 = UIFont(name: "CircularXX-Bold", size: 20)!
}

