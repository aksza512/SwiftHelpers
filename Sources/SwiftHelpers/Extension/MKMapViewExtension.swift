//
//  File.swift
//  
//
//  Created by Alexa Márk on 2022. 04. 27..
//

import Foundation
import MapKit

public extension MKMapView {
    func showLocation(_ location: CLLocation, distanceSpan: Double) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        self.setRegion(region, animated: true)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        let numbersAfterCommaAccuracy: Double = 4
        let ratio = numbersAfterCommaAccuracy * 10
        let isLatitudeEqual = ((lhs.latitude - rhs.latitude) * ratio).rounded(.down) == 0
        let isLongitudeEqual = ((lhs.latitude - rhs.latitude) * ratio).rounded(.down) == 0
        return isLatitudeEqual && isLongitudeEqual
    }
}
