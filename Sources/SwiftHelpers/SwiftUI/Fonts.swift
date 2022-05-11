//
//  Fonts.swift
//  wordpuzzle
//
//  Created by Alexa Mark on 2021. 12. 05..
//

import SwiftUI

public extension Font {
    static let subRegular = Font.system(size: 12, weight: .regular, design: .rounded)
    static let subMedium = Font.system(size: 12, weight: .medium, design: .rounded)
    static let subBold = Font.system(size: 12, weight: .bold, design: .rounded)

    static let textRegular = Font.system(size: 14, weight: .regular, design: .rounded)
    static let textMedium = Font.system(size: 14, weight: .medium, design: .rounded)
    static let textBold = Font.system(size: 14, weight: .bold, design: .rounded)
    
    static let titleRegular = Font.system(size: 16, weight: .regular, design: .rounded)
    static let titleMedium = Font.system(size: 16, weight: .medium, design: .rounded)
    static let titleBold = Font.system(size: 16, weight: .bold, design: .rounded)
    
    static let secondaryHeader = Font.system(size: 18, weight: .bold, design: .rounded)
    static let header1 = Font.system(size: 24, weight: .bold, design: .rounded)
    static let header2 = Font.system(size: 20, weight: .bold, design: .rounded)
}

public extension UIFont {
    static let titleRegular = UIFont.rounded(ofSize: 16)

    static let header2 = UIFont.rounded(ofSize: 20, weight: .bold)
    static let tabBar = UIFont.rounded(ofSize: 11, weight: .bold)

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

