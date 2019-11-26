//
//  Map+Utils.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 21/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {

    func removeAllAnnotations() {
        removeAnnotations(annotations)
    }
}

class PinAnnotation: MKPointAnnotation {

    var pin: PinMO


    init(pin: PinMO) {
        self.pin = pin

        super.init()

        self.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
    }
}
