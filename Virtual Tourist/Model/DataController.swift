//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Debidutt Prasad on 02/11/19.
//  Copyright © 2019 Debidutt Prasad. All rights reserved.
//

import Foundation
import CoreData

class DataController {

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load(_ completionHandler: @escaping (NSPersistentStoreDescription?, Error?) -> Void) {
        persistentContainer.loadPersistentStores(completionHandler: completionHandler)
    }

    func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
}
