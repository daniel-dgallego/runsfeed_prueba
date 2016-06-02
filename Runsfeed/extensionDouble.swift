//
//  extensionDouble.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 2/6/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
