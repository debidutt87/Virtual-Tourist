//
//  PinMOStoreProtocol.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 10/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

protocol PinMOStoreProtocol {

    func createPin(
        usingContext context: NSManagedObjectContext,
        withLocationName locationName: String?,
        andCoordinate coordinate: CLLocationCoordinate2D
    ) -> PinMO
}
