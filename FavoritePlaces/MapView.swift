//
//  MapView.swift
//  FavoritePlaces
//
//  Created by Jakob Ossmann on 11.05.23.
//

import SwiftUI
import MapKit


struct MapView: View {
    // List the variables for the VIew
    @ObservedObject var place:Place
    @State var name = ""
    @State var location = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0))
    @State var delta = 100.0
    @State var zoom = 10.0

    //Build the View with the Map
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Location: \(place.strLocation)")
        
                }
                HStack{
                    Text("Lat/Long: ")
                    TextField("Lat:", text: $latitude)
                    TextField("Long:", text: $longitude)
                    Button("Enter"){
                        checkCoordinates()
                        }
                    
                }
                Slider(value: $zoom, in: 10...60) {
                    if !$0 {
                        fromZoomToDelta(zoom)
                    }
                }
                ZStack{
                    Map(coordinateRegion: $region)
                    VStack(alignment: .leading){
                        Text("Latitude:\(region.center.latitude)").font(.footnote)
                        Text("Longitute:\(region.center.longitude)").font(.footnote)
                        Button("Update"){
                            checkMap()
                        }
                    }.offset(x:10, y: 155)
                }
                .navigationBarTitle("Map of \(name)")
            }.padding()
        
        }
        // Load values from my Data in the View
        .onAppear() {
            name = place.strName
            location = place.strLocation
            latitude = place.strLatitude
            longitude = place.strLongitude
        }
    }
    
    
//    func checkAddress() {
//        Task {
//            await place.fromAddressToCoordinates()
//                place.strAddress = address
//                latitude = place.strLatitude
//                longitude = place.strLongitude
//                saveData()
//                setupRegion()
//        }
//    }
    
    //Use coordinates to get Location
    func checkCoordinates() {
        place.strLatitude = latitude
        place.strLongitude = longitude
        place.fromCoordinatestoAddress()
        location = place.strLocation
            setupRegion()
            saveData()

        }
    
    //recenter Map
    func setupRegion() {
        withAnimation {
            region.center.latitude = place.latitude
            region.center.longitude = place.longitude
        region.span.longitudeDelta = delta
        region.span.latitudeDelta = delta
        }
    }
        
    // Update coordinates and address best on Map
        func checkMap() {
            latitude = String(region.center.latitude)
            longitude = String(region.center.longitude)
            place.latitude = region.center.latitude
            place.longitude = region.center.longitude
            place.fromCoordinatestoAddress()
            location = place.strLocation
            saveData()
            }
    
    //adjust the Zoom
    func fromZoomToDelta(_ zoom: Double){
        checkMap()
        let c1 = -10.0
        let c2 = 3.0
        delta = pow(10.1, zoom / c1 + c2)
        setupRegion()
    }
}

    



