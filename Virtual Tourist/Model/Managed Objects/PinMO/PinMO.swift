//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 02/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import CoreData

/// The managed object representing a pin.
class PinMO: NSManagedObject {

    // MARK: Life cycle

    override func awakeFromInsert() {
        super.awakeFromInsert()

        creationDate = Date()
        album = AlbumMO(context: managedObjectContext!)
    }
}
