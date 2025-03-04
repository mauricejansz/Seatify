//
//  SavedView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-26.
//

import SwiftUI

struct SavedView: View {
    @StateObject private var viewModel = SavedViewModel()
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.leading, 10)

                Button(action: {
                    // Search functionality to be implemented later
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            .padding(.horizontal)

            // List of Saved Restaurants
            if viewModel.savedRestaurants.isEmpty {
                Text("No saved restaurants")
                    .font(.montserrat(size: 16))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.savedRestaurants) { restaurant in
                            RestaurantSearchCard(restaurant: restaurant)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Saved Restaurants")
        .onAppear {
            viewModel.fetchSavedRestaurants()
        }
    }
}
