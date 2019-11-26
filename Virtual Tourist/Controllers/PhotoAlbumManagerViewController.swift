//
//  PhotoAlbumManagerViewController.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 23/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import UIKit
import CoreData

class PhotoAlbumManagerViewController: UIViewController {

    private enum State {
        case displayingAlbumm, loadingAlbum, doesNotHavePhotos
    }

    var dataController: DataController!

    var pin: PinMO!

    var photoStore: PhotoMOStoreProtocol!

    var flickrService: FlickrServiceProtocol!

    var albumDisplayerController: PhotoAlbumDisplayerViewController!

    private var viewState = State.displayingAlbumm {
        didSet {
            albumDisplayerController.displayAlbum()

            switch viewState {
            case .displayingAlbumm:
                enableInformationView(false)
                break

            case .doesNotHavePhotos:
                enableInformationView(true)
                loadingActivityIndicator.stopAnimating()
                informationLabel.text = "There are no photos for this pin. Please, try changing its location or name."

            case .loadingAlbum:
                enableInformationView(true)
                loadingActivityIndicator.startAnimating()
                informationLabel.text = "Loading album photos..."
            }
        }
    }

    @IBOutlet weak var informationLabel: UILabel!

    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var informationViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var informationViewBottomConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(dataController != nil)
        precondition(photoStore != nil)
        precondition(pin != nil)
        precondition(flickrService != nil)

        var placeName: String! = pin.placeName
        if placeName == nil {
            placeName = "Unknown"
        }

        title = placeName

        informationViewHeightConstraint.constant = 2 * (view.frame.height / 8)

        informationViewBottomConstraint.constant = informationViewHeightConstraint.constant
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !pin.album!.hasImages {
            populatePinWithPhotos(pin)

        } else if albumDisplayerController.collectionView.visibleCells.isEmpty {
            viewState = .displayingAlbumm
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        func displayFetchError() {
            let alert = self.makeErrorAlertController(
                withMessage: "The photos of the album couldn't be saved. Please, make sure you have enough space available in your device."
            )
            self.present(alert, animated: true)
        }

        // Save any images into core data.
        let backgroundContextForSaving = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContextForSaving.parent = dataController.viewContext

        backgroundContextForSaving.perform {
            do {
                try self.pin.managedObjectContext?.save()

                self.dataController.viewContext.performAndWait {
                    do {
                        try self.dataController.viewContext.save()
                    } catch {
                        self.dataController.viewContext.rollback()
                        displayFetchError()
                    }
                }
            } catch {
                self.pin.managedObjectContext?.rollback()
                displayFetchError()
            }
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Inject the dependencies.
        if segue.identifier == SegueIdentifiers.ShowPhotoAlbumDisplayer {
            guard let albumDisplayerController = segue.destination as? PhotoAlbumDisplayerViewController else {
                preconditionFailure("The album display controller must be configured.")
            }
            self.albumDisplayerController = albumDisplayerController
            self.albumDisplayerController.pin = pin
            self.albumDisplayerController.flickrService = flickrService
            self.albumDisplayerController.photosFetchedResultsController = photoStore.getPhotosFetchedResultsController(
                fromAlbum: pin.album!,
                fetchingFromContext: dataController.viewContext
            )
        }
    }

    @IBAction func refreshAlbum(_ sender: UIBarButtonItem? = nil) {
        // Remove all photos from the album.
        if let photos = pin.album?.photos {
            if let photosSet = photos as? Set<PhotoMO> {
                photosSet.forEach { self.pin.managedObjectContext?.delete($0) }
            }
        }

        populatePinWithPhotos(pin)
    }

    @IBAction func editPinName(_ sender: UIBarButtonItem) {
        // Display an alert view with a text field.
        let alert = makeAlertController(
            withTitle: "Edit pin name",
            andMessage: "Change the location name to get more accurate photos in your album."
        )
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Edit", style: .default) { action in
            if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                self.pin.placeName = newName
                self.title = newName
                self.refreshAlbum()
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    private func populatePinWithPhotos(_ pin: PinMO) {
        viewState = .loadingAlbum

        func displayDownloadError(withMessage message: String) {
            DispatchQueue.main.async {
                self.viewState = self.pin.album!.hasImages ? .displayingAlbumm : .doesNotHavePhotos
                self.present(self.makeErrorAlertController(withMessage: message), animated: true)
            }
        }

        flickrService.populatePinWithPhotosFromFlickr(pin) { [weak self] pin, error in
            guard let self = self else { return }

            guard error == nil, pin != nil else {
                displayDownloadError(withMessage: "The photos couldn't be downloaded. Please, check your connection and try again later.")
                return
            }

            DispatchQueue.main.async {
                self.viewState = self.pin.album!.hasImages ? .displayingAlbumm : .doesNotHavePhotos
            }
        }
    }
    
    private func enableInformationView(_ isEnabled: Bool) {
        informationViewBottomConstraint.constant = isEnabled ? 0 : informationViewHeightConstraint.constant

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
