//
//  RestaurantMapListScreen.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-24.
//

import SwiftUI
import GoogleMaps

import SwiftUI
import GoogleMaps

struct RestaurantMapListView: View {
    let restaurants: [Restaurant]
    @State private var selectedRestaurant: Restaurant?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            GoogleMapView(
                restaurants: restaurants,
                onTapMarker: { restaurant in
                    selectedRestaurant = restaurant
                }
            )

            NavigationLink(
                value: selectedRestaurant,
                label: {
                    EmptyView()
                }
            )
            .hidden()
        }
        .navigationDestination(item: $selectedRestaurant) { restaurant in
            RestaurantDetailView(restaurant: restaurant)
        }
        .ignoresSafeArea()
    }
}
