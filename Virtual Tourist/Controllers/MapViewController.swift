//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 02/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    var dataController: DataController!

    var pinStore: PinMOStoreProtocol!

    var albumStore: AlbumMOStoreProtocol!

    var flickrService: FlickrServiceProtocol!

    @IBOutlet weak var mapView: MKMapView!


    deinit {
        stopObservingNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(dataController != nil)
        precondition(pinStore != nil)
        precondition(albumStore != nil)
        precondition(flickrService != nil)

        configureNavigationController()

        startObservingNotification(withName: .NSManagedObjectContextDidSave,
                                   usingSelector: #selector(updateViewContext(fromNotification:)))

        mapView.delegate = self
        mapView.setRegion(
            MKCoordinateRegion(center: mapView.region.center,
                               span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 40)
        ), animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayPins()
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ShowPhotoAlbumManager {
            guard let selectedPinAnnotation = mapView.selectedAnnotations.first as? PinAnnotation,
                let albumManagerController = segue.destination as? PhotoAlbumManagerViewController else {
                    assertionFailure("Couldn't prepare the album controller.")
                    return
            }
            let selectedPin = selectedPinAnnotation.pin
            
            albumManagerController.pin = selectedPin
            albumManagerController.flickrService = flickrService
            albumManagerController.dataController = dataController
            albumManagerController.photoStore = albumStore.photoStore
        }
    }

    @objc private func updateViewContext(fromNotification notification: Notification) {
        dataController.viewContext.mergeChanges(fromContextDidSave: notification)
    }

    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let pressMapCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            createPin(forCoordinate: pressMapCoordinate)
        default:
            break
        }
    }

    private func createPin(forCoordinate coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                var locationName: String?

                if let placemark = placemarks?.first {
                    locationName = placemark.placeName
                }

                do {
                    let createdPin = self.pinStore.createPin(
                        usingContext: self.dataController.viewContext,
                        withLocationName: locationName,
                        andCoordinate: coordinate
                    )

                    try self.dataController.save()

                    self.flickrService.populatePinWithPhotosFromFlickr(createdPin) { createdPin, error in
                        guard error == nil, createdPin != nil else {
                            /* Fail silently when in the map controller. */
                            return
                        }

                    }

                    self.display(createdPin: createdPin)
                } catch {
                    // TODO: Alert the user of the error.
                }
            }
        }
    }

    private func displayPins() {
        mapView.removeAllAnnotations()

        let pinsRequest: NSFetchRequest<PinMO> = PinMO.fetchRequest()
        pinsRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        dataController.viewContext.perform {
            do {
                let pins = try self.dataController.viewContext.fetch(pinsRequest)
                self.mapView.addAnnotations(pins.map { PinAnnotation(pin: $0) })
            } catch {
                let alert = self.makeAlertController(withTitle: "Error", andMessage: "Couldn't load the added pins.")
                self.present(alert, animated: true)
            }
        }
    }

    private func display(createdPin pin: PinMO) {
        mapView.addAnnotation(PinAnnotation(pin: pin))
    }

    private func configureNavigationController() {
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

extension MapViewController: MKMapViewDelegate {


    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation is PinAnnotation else {
            return
        }

        performSegue(withIdentifier: SegueIdentifiers.ShowPhotoAlbumManager, sender: self)
    }
}

extension MapViewController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return PushMapDetailsAnimator()

        case .pop:
            return PopMapDetailsAnimator()

        default:
            return nil
        }
    }
}

private class PushMapDetailsAnimator: NSObject, UIViewControllerAnimatedTransitioning {


    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        guard let currentMapController = transitionContext.viewController(forKey: .from) as? MapViewController else {
            preconditionFailure("The from controller must be a map controller.")
        }
        let mapRegion = currentMapController.mapView.region

        guard let detailsViewController = transitionContext.viewController(forKey: .to) as? PhotoAlbumManagerViewController else {
            preconditionFailure("The from controller must be a album manager controller.")
        }
        detailsViewController.albumDisplayerController.detailsMapController.mapView.setRegion(mapRegion, animated: false)

        toView.alpha = 0
        containerView.addSubview(toView)

        UIView.animate(withDuration: 0.5, animations: {
            toView.alpha = 1
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

private class PopMapDetailsAnimator: NSObject, UIViewControllerAnimatedTransitioning {


    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        guard let currentDetailsViewController = transitionContext.viewController(forKey: .from) as? PhotoAlbumManagerViewController else {
            preconditionFailure("The from controller must be an album manager controller.")
        }
        let detailsMapRegion = currentDetailsViewController.albumDisplayerController.detailsMapController.mapView.region

        guard let mapViewController = transitionContext.viewController(forKey: .to) as? MapViewController else {
            preconditionFailure("The from controller must be a map view controller.")
        }
        mapViewController.mapView.setRegion(detailsMapRegion, animated: false)

        toView.alpha = 0
        containerView.addSubview(toView)

        UIView.animate(withDuration: 0.5, animations: {
            toView.alpha = 1
        }) { _ in
            mapViewController.mapView.setRegion(
                MKCoordinateRegion(center: detailsMapRegion.center,
                                   span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 40)),
                animated: true
            )
            transitionContext.completeTransition(true)
        }
    }
}
