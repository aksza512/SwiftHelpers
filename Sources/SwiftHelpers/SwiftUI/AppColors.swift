//
//  File.swift
//  
//
//  Created by Márk József Alexa on 2022. 01. 06..
//

import Foundation
import SwiftUI

public protocol AppButtonColors {
    var buttonPrimaryBgrNormal: Color { get }
    var buttonPrimaryBgrPressed: Color { get }
    var buttonPrimaryBgrDisabled: Color { get }

    var buttonSecondaryBgrNormal: Color { get }
    var buttonSecondaryBgrPressed: Color { get }
    var buttonSecondaryBgrDisabled: Color { get }

    var buttonTertiaryBgrNormal: Color { get }
    var buttonTertiaryBgrPressed: Color { get }
    var buttonTertiaryBgrDisabled: Color { get }

    var buttonTextPrimaryNormal: Color { get }
    var buttonTextPrimaryDisabled: Color { get }

    var buttonTextSecondaryNormal: Color { get }
    var buttonTextSecondaryDisabled: Color { get }

    var buttonTextTertiaryNormal: Color { get }
    var buttonTextTertiaryDisabled: Color { get }
}

public protocol AppTextFieldColors {
    var title: Color { get }
    var titleImage: Color { get }
    var trailingButton: Color { get }
    var bgr: Color { get }
    var bgrDisabled: Color { get }
    var hintText: Color { get }
    var cursorColor: Color { get }
    var borderFocused: Color { get }
    var border: Color { get }
    var validated: Color { get }
    var warning: Color { get }
    var error: Color { get }
    var text: Color { get }
    var textDisabled: Color { get }
    var deleteButton: Color { get }
    var eye: Color { get }
}

public extension UIColor {
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
    ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return darkModeColor()
            default:
                return lightModeColor()
            }
        }
    }
}

@available(iOS 14.0, *)
public extension Color {
    init(
        light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color
    ) {
        self.init(UIColor(
            light: UIColor(lightModeColor()),
            dark: UIColor(darkModeColor())
        ))
    }
}

public extension UIColor {

    /**
     Create a lighter color
     */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }

    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }

    /**
     Changing R, G, B values
     */

    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {

            let pFactor = (100.0 + percentage) / 100.0

            let newRed = (red*pFactor).clamped(to: 0.0 ... 1.0)
            let newGreen = (green*pFactor).clamped(to: 0.0 ... 1.0)
            let newBlue = (blue*pFactor).clamped(to: 0.0 ... 1.0)

            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
        }

        return self
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        if self > range.upperBound {
            return range.upperBound
        } else if self < range.lowerBound {
            return range.lowerBound
        } else {
            return self
        }
    }
}
