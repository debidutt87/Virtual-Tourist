//
//  PinMOStore.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 13/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

struct PinMOStore: PinMOStoreProtocol {

    func createPin(
        usingContext context: NSManagedObjectContext,
        withLocationName locationName: String?,
        andCoordinate coordinate: CLLocationCoordinate2D) -> PinMO {

        let pin = PinMO(context: context)
        pin.placeName = locationName
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude

        return pin
    }
}
