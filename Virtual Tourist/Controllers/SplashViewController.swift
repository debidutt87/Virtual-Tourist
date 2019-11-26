//
//  SplashViewController.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 02/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    var dataController: DataController!

    var pinStore: PinMOStoreProtocol!

    var albumStore: AlbumMOStoreProtocol!

    var flickrService: FlickrServiceProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        precondition(dataController != nil)
        precondition(pinStore != nil)
        precondition(albumStore != nil)
        precondition(flickrService != nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dataController.load { storeDescription, error in
            guard error == nil else {
                debugPrint("An error occurred - \(error!)")
                // TODO: Display an error to the user.
                return
            }

            self.performSegue(withIdentifier: SegueIdentifiers.ShowMap, sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ShowMap,
            let navigationController = segue.destination as? UINavigationController,
            let mapController = navigationController.visibleViewController as? MapViewController {

            navigationController.modalPresentationStyle = .custom
            navigationController.transitioningDelegate = self

            mapController.dataController = dataController
            mapController.pinStore = pinStore
            mapController.albumStore = albumStore
            mapController.flickrService = flickrService
        }
    }
}

extension SplashViewController: UIViewControllerTransitioningDelegate {

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension SplashViewController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let currentView = view!
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        let currentViewSnapshot = currentView.snapshotView(afterScreenUpdates: false)!
        container.addSubview(toView)
        container.addSubview(currentViewSnapshot)

        UIView.animate(withDuration: 0.5, animations: {
            currentViewSnapshot.alpha = 0
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }
}
