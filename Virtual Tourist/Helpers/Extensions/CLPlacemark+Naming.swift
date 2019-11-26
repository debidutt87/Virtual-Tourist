//
//  CLPlacemark+Naming.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 26/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    
    var placeName: String? {
        var placeName = ""

        if let administrativeArea = administrativeArea, !administrativeArea.isEmpty {
            placeName = administrativeArea
        }

        if let locality = locality, !locality.isEmpty {
            placeName = (placeName.isEmpty ? "" : ", ") + locality
        }

        if let name = name, !name.isEmpty {
            placeName = (placeName.isEmpty ? "" : ", ") + name
        }

        return placeName.isEmpty ? nil : placeName
    }
}
