//
//  Persistency.swift
//  FavoritePlaces
//
//  Created by Jakob Ossmann on 29.04.23.
//

import Foundation
import CoreData

// Persistency container to fetch the CoreData
struct PH {
    static let shared = PH()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
//Initialize data
     init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Loading error with \(error)")
            }
        }

        context = container.viewContext
    }
}
