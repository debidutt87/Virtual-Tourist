//
//  FlickrServiceProtocol.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 12/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import UIKit

protocol FlickrServiceProtocol {

    var apiClient: APIClientProtocol { get }

    var albumStore: AlbumMOStoreProtocol { get }

    var dataController: DataController { get }

    init(apiClient: APIClientProtocol, albumStore: AlbumMOStoreProtocol, dataController: DataController)

    func populatePinWithPhotosFromFlickr(
        _ pin: PinMO,
        withCompletionHandler handler: @escaping (PinMO?, Error?) -> Void
    )
    
    func requestImages(
        relatedToPin pin: PinMO,
        usingCompletionHandler handler: @escaping ((FlickrSearchResponseData?, URLSessionTask.TaskError?) -> Void)
    )
    
    func requestImage(
        fromUrl flickrUrl: URL,
        usingComplitionHandler handler: @escaping (UIImage?, URLSessionTask.TaskError?) -> Void
    )
}
