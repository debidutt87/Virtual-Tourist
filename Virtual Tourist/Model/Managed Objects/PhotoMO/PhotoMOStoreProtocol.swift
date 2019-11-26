//
//  PhotoMOStoreProtocol.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 13/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import CoreData

protocol PhotoMOStoreProtocol {

    func createPhoto(fromFlickrImage flickrImage: FlickrImage, associatedToAlbum album: AlbumMO) -> PhotoMO

    func getPhotosFetchedResultsController(
        fromAlbum album: AlbumMO,
        fetchingFromContext context: NSManagedObjectContext
        ) -> NSFetchedResultsController<PhotoMO>
}
