//
//  DetailsMapViewController.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 23/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import UIKit
import MapKit

class DetailsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var pin: PinMO!
    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(pin != nil)

        mapView.addAnnotation(PinAnnotation(pin: pin))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mapView.selectAnnotation(mapView.annotations.first!, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let pinAnnotation = mapView.annotations.first!
        mapView.setRegion(
            MKCoordinateRegion(center: pinAnnotation.coordinate,
                               span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)),
            animated: true
        )
    }
}

extension DetailsMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.isDraggable = true

        return view
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        didChange newState: MKAnnotationView.DragState,
        fromOldState oldState: MKAnnotationView.DragState
        ) {
        switch newState {
        case .starting:
            view.dragState = .dragging

        case .canceling, .ending:
            view.dragState = .none
            // Finish the drag by setting the coordinates of the pin managed object.
            guard let coordinate = view.annotation?.coordinate else { preconditionFailure() }
            pin.latitude = coordinate.latitude
            pin.longitude = coordinate.longitude

        default: break
        }
    }
}
