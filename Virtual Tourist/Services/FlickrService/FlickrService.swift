//
//  FlickrService.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 12/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import UIKit

class FlickrService: FlickrServiceProtocol {

    private typealias photosRequestCompletionHandler = (PinMO?, Error?) -> Void

    private var photosRequestHandlers: [PinMO: [photosRequestCompletionHandler]] = [:]

    private let flickrAPIKey: String

    let apiClient: APIClientProtocol

    var albumStore: AlbumMOStoreProtocol

    var dataController: DataController

    private lazy var baseURL: URL = {
        var components = URLComponents()
        components.scheme = API.Scheme
        components.host = API.Host
        components.path = API.Path
        return components.url!
    }()

    required init(apiClient: APIClientProtocol, albumStore: AlbumMOStoreProtocol, dataController: DataController) {
        guard let flickrAPIKey = Bundle.main.object(forInfoDictionaryKey: "Flickr api key") as? String else {
            preconditionFailure("The flickr API key must be properly configured.")
        }

        self.apiClient = apiClient
        self.flickrAPIKey = flickrAPIKey
        self.albumStore = albumStore
        self.dataController = dataController
    }

    func populatePinWithPhotosFromFlickr(
        _ pin: PinMO,
        withCompletionHandler handler: @escaping (PinMO?, Error?) -> Void
        ) {
        let pinObjectID = pin.objectID

        if var handlers = photosRequestHandlers[pin] {
            handlers.append(handler)
            photosRequestHandlers[pin] = handlers

        } else {
            photosRequestHandlers[pin] = [handler]
            requestImages(relatedToPin: pin) { flickrResponseData, taskError in
             
                let handlers = self.photosRequestHandlers[pin]!

                self.photosRequestHandlers[pin] = nil

                guard taskError == nil, let flickrResponseData = flickrResponseData else {
                    handlers.forEach { $0(nil, taskError!) }
                    return
                }

                self.dataController.persistentContainer.performBackgroundTask { context in
                    guard let pinInBackgroundContext = context.object(with: pinObjectID) as? PinMO else {
                        preconditionFailure("Pin must be correctly fetched in bg context.")
                    }

                    do {
                        try self.albumStore.addPhotos(fromFlickrImages: flickrResponseData.data.photos,
                                                      toAlbum: pinInBackgroundContext.album!)
                        handlers.forEach { $0(pin, nil) }
                    } catch {
                        handlers.forEach { $0(nil, error) }
                    }
                }
            }
        }
    }

    func requestImages(
        relatedToPin pin: PinMO,
        usingCompletionHandler handler: @escaping ((FlickrSearchResponseData?, URLSessionTask.TaskError?) -> Void)
        ) {
        var parameters = [
            ParameterKeys.APIKey: flickrAPIKey,
            ParameterKeys.Format: ParameterDefaultValues.Format,
            ParameterKeys.NoJsonCallback: ParameterDefaultValues.NoJsonCallback,
            ParameterKeys.Method: Methods.PhotosSearch,
            ParameterKeys.Extra: ParameterDefaultValues.ExtraMediumURL,
            ParameterKeys.Page: ParameterDefaultValues.PageNumber
            ] 

        if let locationName = pin.placeName {
            parameters[ParameterKeys.Text] = locationName
        } else {
            parameters[ParameterKeys.BoundingBox] =
            "\(pin.longitude - 0.1), \(pin.latitude - 0.1), \(pin.longitude + 0.1), \(pin.latitude + 0.1)"
        }

        let task = apiClient.makeGETDataTaskForResource(
            withURL: baseURL,
            parameters: parameters,
            headers: nil
        ) { data, error in
            UIApplication.shared.enableNetworkingActivityIndicator(false)

            guard error == nil, let data = data else {
                handler(nil, error!)
                return
            }

            let decoder = JSONDecoder()
            do {
                let flickrResponseData = try decoder.decode(FlickrSearchResponseData.self, from: data)
                handler(flickrResponseData, nil)
            } catch {
                handler(nil, .malformedJsonResponse)
            }
        }
        UIApplication.shared.enableNetworkingActivityIndicator(true)

        task.resume()
    }

    func requestImage(
        fromUrl flickrUrl: URL,
        usingComplitionHandler handler: @escaping (UIImage?, URLSessionTask.TaskError?) -> Void
        ) {
        let task = apiClient.makeGETDataTaskForResource(
            withURL: flickrUrl,
            parameters: [:],
            headers: [:]
        ) { data, taskError in
            UIApplication.shared.enableNetworkingActivityIndicator(false)

            guard let data = data, taskError == nil else {
                handler(nil, taskError)
                return
            }

            guard let image = UIImage(data: data) else {
                handler(nil, .unexpectedResource)
                return
            }

            handler(image, nil)
        }
        UIApplication.shared.enableNetworkingActivityIndicator(true)

        task.resume()
    }
}
