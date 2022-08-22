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
                var strings: [String] = []
                strings.safeAdd(placeMark?.locality)
                strings.safeAdd(placeMark?.name)
                let address = strings.joined(separator: ", ")
                completionBlock(address, isoCountryCode == countryForValidation)
            }
        })
    }
    
}
