//
//  File.swift
//  
//
//  Created by Alexa Márk on 2022. 03. 28..
//

import Foundation
import CoreLocation

public extension CLGeocoder {
    
    func reverseGeoCoding(location: CLLocation, countryForValidation: String, completionBlock: @escaping (_ placeMarkName: String?, _ validCountry: Bool) -> Void) {
        self.reverseGeocodeLocation(location, completionHandler: {(_ placemarks: [Any]?, _ error: Error?) -> Void in
            if error == nil {
                let placeMark = placemarks?.last as? CLPlacemark
                let isoCountryCode = placeMark?.isoCountryCode
                var addressParts = placeMark?.addressDictionary?["FormattedAddressLines"] as? [String]
                if addressParts?.count != 1 {
                    addressParts?.removeLast()
                }
                var address = addressParts?.joined(separator: ", ")
                if let postalCode = placeMark?.postalCode {
                    let addressString = NSString(string: address ?? "")
                    address = addressString.replacingOccurrences(of: postalCode + " ", with: "")
                }
                completionBlock(address, isoCountryCode == countryForValidation)
            }
        })
    }
    
}
