//
//  File.swift
//  
//
//  Created by Alexa Márk on 2021. 06. 03..
//

import Foundation

public extension Double {
	/// Rounds the double to decimal places value
	func rounded(toPlaces places:Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
    
    func formatDecimalEnglish() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.decimalSeparator = "."
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 2
        return formater.string(from: NSNumber(value: self)) ?? ""
    }
}
