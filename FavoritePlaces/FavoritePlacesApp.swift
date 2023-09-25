//
//  FavoritePlacesApp.swift
//  FavoritePlaces
//
//  Created by Jakob Ossmann on 29.04.23.
//

import SwiftUI

@main
struct FavoritePlacesApp: App {
    // Assign the data model that's been fetched from the persistency file to the App
    var coreData = PH.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, coreData.container.viewContext)
        }
    }
}
