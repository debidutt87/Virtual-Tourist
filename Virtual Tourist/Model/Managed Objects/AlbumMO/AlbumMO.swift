//
//  AlbumMO.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 13/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import CoreData

class AlbumMO: NSManagedObject {

    var hasImages: Bool {
        return (photos?.count ?? 0) > 0
    }

    override func awakeFromInsert() {
        super.awakeFromInsert()

        creationDate = Date()
        id = UUID().uuidString
    }
}
