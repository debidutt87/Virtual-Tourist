//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 11/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var dataController: DataController!


    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        guard let splashController = window?.rootViewController as? SplashViewController else {
            preconditionFailure("Couldn't get the initial app controller.")
        }
        dataController = DataController(modelName: "Virtual_Tourist")
        splashController.dataController = dataController
        splashController.pinStore = PinMOStore()
        splashController.albumStore = AlbumMOStore(photoStore: PhotoMOStore())
        splashController.flickrService = FlickrService(
            apiClient: APIClient(session: .shared),
            albumStore: splashController.albumStore,
            dataController: dataController
        )

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        try? dataController.save()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        try? dataController.save()
    }
}

