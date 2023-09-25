//
//  ViewModel.swift
//  FavoritePlaces
//
//  Created by Jakob Ossmann on 29.04.23.
//

import Foundation
import CoreData
import SwiftUI
import MapKit

// Load the default Image or the Images in store
let defaultImage = Image(systemName: "photo").resizable()
var downloadImages : [URL:Image] = [:]



//set the variables for the Place Core Data entity
extension Place  {

    
    var strName : String {
        get {
            self.name ?? ""
        }
        set {
            self.name = newValue
        }
    }
    var strLocation : String {
        get {
            self.location ?? ""
        }
        set {
            self.location = newValue
        }
    }
    var strDescription : String {
        get {
            self.placeDescription ?? ""
        }
        set {
            self.placeDescription = newValue
        }
    }
    var strUrl: String {
        get {
            self.imgurl?.absoluteString ?? ""
        }
        set {
            guard let url = URL(string: newValue) else {return}
            self.imgurl = url
        }
    }
    var strLatitude: String {
        get{String(format: "%.5f", latitude)}
        set{
            guard let lat = Double(newValue), lat <= 90.0, lat >= -90.0 else {return}
                latitude = lat
        }
    }
    var strLongitude: String {
        get{String(format: "%.5f", longitude)}
        set{
            guard let long = Double(newValue), long <= 180.0, long >= -180.0 else {return}
            longitude = long
        }
    }
    
    // Variable for the Preview list. right now its minimal maybe will exapnd with more
    var rowDisplay:String {
        "\(self.strName)"
    }
    
    // load the Image from the url
    func getImage() async ->Image {
        guard let url = self.imgurl else {return defaultImage}
        if let image = downloadImages[url] {return image}
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiimg = UIImage(data: data) else {return defaultImage}
            let image = Image(uiImage: uiimg).resizable()
            downloadImages[url]=image
            return image
        }catch {
            print("error in download image \(error)")
        }
        return defaultImage
    }
    
//    func fromAddressToCoordinates() async {
//                let geocoder = CLGeocoder()
//                let marks = try? await geocoder.geocodeAddressString(self.address ?? "Brisbane")
//
//                    if let mark = marks?.first {
//                        let coordinates:CLLocationCoordinate2D = mark.location!.coordinate
//                        self.latitude = coordinates.latitude
//                        self.longitude = coordinates.longitude
//                    }
//                }
    
    // get the Address Location from latitude and longitutde
    func fromCoordinatestoAddress() {

        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)){ marks, error in
            if let err = error {
                print("error in fromLocToAddress: \(err)")
                return
            }
            let mark = marks?.first
            let strLocation = mark?.name ?? mark?.country ?? mark?.locality ?? mark?.administrativeArea ?? "No name"
            self.strLocation = strLocation
        }
    }
    
}

// save the Data back into my CoreData
func saveData() {
    let ctx = PH.shared.container.viewContext
    do {
        try ctx.save()
    }catch {
        print("Error to save with \(error)")
    }
}

// load Default Data
func loadDefaultData() {
    
    // array with dummy values
    let defaultPlaces = [["GC Campus", "Southport", "The best Uni Campus in the World", 1.234567, 2.345678, "https://www.universitiesaustralia.edu.au/wp-content/uploads/2019/05/Griffith-2020_Web-4-1333x1000.jpg"],
                         ["Snapper Rocks", "Tweed Heads", "The best surf break in the World", 3.456789, 4.567890, "https://www.aquabumps.com/content/uploads/2021/05/Aquabumps_May-28-2021_DSD01401-800x533.jpg"],
                         ["QLD Art Gallery", "Brisbane", "Finest modern Art", 5.678901, 6.789012, "https://cdn.sanity.io/images/m2obzhc2/production/9083aaa743e11a800755bb2eb757ffa7986f3720-1560x1031.jpg"],
    
    ]
    let ctx = PH.shared.container.viewContext
    
    // loop through the array and assign the values to the CoreData attributes
    defaultPlaces.forEach {
            let place = Place(context: ctx)
            place.name = $0[0] as? String
            place.location = $0[1] as? String
            place.placeDescription = $0[2] as? String
            place.latitude = $0[3] as? Double ?? 0.0
            place.longitude = $0[4] as? Double ?? 0.0
            place.imgurl = URL(string: $0[5] as? String ?? "")

        }
        saveData()
}


func deletePlaces(places: [Place]) {
    let ctx = PH.shared.container.viewContext
    places.forEach{
        ctx.delete($0)
    }
    saveData()
}
