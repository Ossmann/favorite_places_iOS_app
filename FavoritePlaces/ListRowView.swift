//
//  SwiftRowView.swift
//  FavoritePlaces
//
//  Created by Jakob Ossmann on 29.04.23.
//

import SwiftUI


// Preview the Items summary int the main List
struct ListRowView: View {
    var place: Place
    @State var name = ""
    @State var image = defaultImage
    var body: some View {
        HStack {
            image.frame(width: 50, height: 50).clipShape(Circle())
            Text(name)
        }
        .onAppear{
            name = place.strName
        }
    
        .task {
            image = await place.getImage()
        }
    }
}

