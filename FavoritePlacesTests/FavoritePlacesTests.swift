//
//  FavoritePlacesTests.swift
//  FavoritePlacesTests
//
//  Created by Jakob Ossmann on 29.04.23.
//

import XCTest
@testable import FavoritePlaces

class FavoritePlacesTests: XCTestCase {
    
    var viewModel: PH!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = PH()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    // test if the defaultImage variable is not nil
    func testDefaultImage() throws {
        XCTAssertNotNil(defaultImage)
    }
    
    func testCheckCoordinates() {
           let place = Place() // Create an instance of the Place object
           let mapView = MapView(place: place) // Create an instance of the MapView with the place object
           
           mapView.latitude = "37.7749" // Set the latitude value
           mapView.longitude = "-122.4194" // Set the longitude value
           
           mapView.checkCoordinates() // Call the function to test
           
           // Assert that the address is not nil
           XCTAssertNotNil(place.strLocation, "Address should not be nil")

    
    // test if the getImage() function returns an Image
    func testGetImage() async throws {
        let place = Place(context: viewModel.container.viewContext)
        place.strUrl = "https://picsum.photos/200"
        let image = await place.getImage()
        XCTAssertNotNil(image)
    }
}
}
