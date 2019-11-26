//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 11/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PhotoMO: NSManagedObject {

    var image: UIImage?

    override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
