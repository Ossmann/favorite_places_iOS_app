//
//  DetailView.swift
//  FavoritePlaces
//
//  Created by Jakob Ossmann on 29.04.23.
//

import SwiftUI

struct DetailView: View {
    var place:Place 
    @State var name = ""
    @State var location = ""
    @State var description = ""
    @State var url = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var isEditing = false
    @State var image = defaultImage
    var body: some View {
            VStack {
                
                //when in edit mode edit the Name of the place below the NavigationTitle
                if isEditing {
                TextField("Edit Place Name:", text: $name)
                }
 
                List{
                    // show just the location above the image in normal view
                    if !isEditing {
                            Text("Location: \(location)")
                        VStack{
                            Text("Place Description:")
                            Text(description)
                        }
                        
                        NavigationLink(destination: MapView(place: place)) {
                            HStack{
                            //should be mini Image of Map
                            Image(systemName: "map").foregroundStyle(.teal, .blue)
                            Text("Map of \(name)")
                            }
                        }
                        Text("latitude: \(latitude)")
                        Text("longitude: \(longitude)")
                }
                    // if we are editing list place, location, and the url of the image
                    else {
                        HStack{
                            Text("Edit location: ")
                            TextField("City XYZ:", text: $location)
                        }
                        HStack {
                            Text("Edit url: ")
                            TextField("Enter Image Url:", text: $url)
                        }
                        VStack{
                            Text("Location description: ")
                            TextField("Edit location description:", text: $description)
                        }
                        HStack {
                            Text("Edit latitude: ")
                            TextField("000.000:", text: $latitude)
                        }
                        HStack {
                            Text("Edit longitude: ")
                            TextField("0000.000:", text: $longitude)
                        }
                            
                    }
            }
        }
        // the title of the Place. changes if the name variable changes
                .navigationTitle(name)
        
        // add a button to Edit the Details of the Place
                .navigationBarItems(trailing: Button("\(isEditing ? "Done" : "Edit")"){
                    
                    // update the values of Place entity if edited
                    if (isEditing) {
                        place.strName = name
                        place.strLocation = location
                        place.strDescription = description
                        place.latitude = Double(latitude) ?? 0.0
                        place.longitude = Double(longitude) ?? 0.0
                        place.strUrl = url
                        saveData()
                        Task {
                            image = await place.getImage()
                        }
                    }
                    
                    // go back to standard view or editView
                    isEditing.toggle()
                })
            
        //Show the image and style it
            image.scaledToFit().cornerRadius(20).shadow(radius: 20)
      
        // set the variables when the view appears
        .onAppear{
            name = place.strName
            location = place.strLocation
            description = place.strDescription
            latitude = place.strLatitude
            longitude = place.strLongitude
            url = place.strUrl
            
            
            print("name:", name)
            print("address:", location)
            print("description:", description)
            print("latitude:", latitude)
            print("longitude:", longitude)
            print("url:", url)
        }
        .task {
            await image = place.getImage()
        }
    }
}
