//
//  AlbumMOStoreProtocol.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 13/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation

protocol AlbumMOStoreProtocol {

    var photoStore: PhotoMOStoreProtocol { get }

    init(photoStore: PhotoMOStoreProtocol)

    func addPhotos(fromFlickrImages flickrImages: [FlickrImage], toAlbum album: AlbumMO) throws
}
