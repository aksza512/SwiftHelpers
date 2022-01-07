//
//  Fonts.swift
//  wordpuzzle
//
//  Created by Alexa Mark on 2021. 12. 05..
//

import SwiftUI

public extension Font {
    // MARK: Heading
    static let headings1 = Font.system(size: 40, weight: .bold, design: .rounded)
    static let headings2 = Font.system(size: 32, weight: .bold, design: .rounded)
    static let headings3 = Font.system(size: 24, weight: .bold, design: .rounded)
    static let headings4 = Font.system(size: 20, weight: .bold, design: .rounded)
    static let headings5 = Font.system(size: 16, weight: .bold, design: .rounded)
    static let headings6 = Font.system(size: 14, weight: .bold, design: .rounded)
    static let headings7 = Font.system(size: 12, weight: .bold, design: .rounded)

    // MARK: Lead
    static let lead1 = Font.system(size: 40, design: .rounded)
    static let lead2 = Font.system(size: 32, design: .rounded)
    static let lead3 = Font.system(size: 24, design: .rounded)
    static let lead4 = Font.system(size: 20, design: .rounded)

    // MARK: BodyFont
    static let body1 = Font.system(size: 16, design: .rounded)
    static let body2 = Font.system(size: 14, design: .rounded)
    static let body3 = Font.system(size: 12, design: .rounded)
}

public extension UIFont {
    static let body1 = UIFont.rounded(ofSize: 16)

    static let headings4 = UIFont.rounded(ofSize: 20, weight: .bold)

    static func rounded(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont

        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}

