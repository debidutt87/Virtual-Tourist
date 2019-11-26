//
//  AlbumMOStore.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 13/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation

struct AlbumMOStore: AlbumMOStoreProtocol {


    var photoStore: PhotoMOStoreProtocol


    init(photoStore: PhotoMOStoreProtocol) {
        self.photoStore = photoStore
    }

    func addPhotos(fromFlickrImages flickrImages: [FlickrImage], toAlbum album: AlbumMO) throws {
        guard let context = album.managedObjectContext else {
            preconditionFailure("Album instances passed to this method must have a context")
        }

        flickrImages.forEach { _ = photoStore.createPhoto(fromFlickrImage: $0, associatedToAlbum: album) }
        try context.save()
    }
}
