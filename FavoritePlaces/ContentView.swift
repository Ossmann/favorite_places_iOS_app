//
//  ContentView.swift
//  FavoritePlaces
//
//  Created by Jakob Ossmann on 29.04.23.
//

import SwiftUI

struct ContentView: View {
    // load data
    @Environment(\.managedObjectContext) var ctx
    //sort the items alphabeticcally
    @FetchRequest(entity: Place.entity(), sortDescriptors: [
        NSSortDescriptor(key: "name", ascending: true)
    ])
    var places: FetchedResults<Place>
        
    
    var body: some View {
        NavigationView {
            VStack {
                // For every place entry in the Data create a List entry in the detail view
                List {
                    ForEach(places) { place in
                        NavigationLink(destination: DetailView(place: place)) {
                            ListRowView(place: place)
                        }
                    }
                    .onDelete { indexSet in
                         delete(at: indexSet)
                     }
                }
            }
            //call the default data function if there is no data saved
            .task {
                if(places.count == 0) {
                    loadDefaultData()
                }
            }
                
            .padding()
            .navigationTitle("My Favorite Places")
            .navigationBarItems(
                leading: Button("+") {
                    addNewPlace()
                },
                trailing: EditButton()
            )
        }
    }
    
    func delete(at idx: IndexSet) {
        var plcs:[Place] = []
        idx.forEach{
            plcs.append(places[$0])
        }
        deletePlaces(places:plcs)
    }
    
    // adds a new place to my List of places
        func addNewPlace() {
            let place = Place(context: ctx)
            place.name = "New Place"
            place.placeDescription = "Description Template"
            place.location = "Greenwich"
            saveData()
        }
    }
