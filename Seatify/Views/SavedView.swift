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
        VStack(spacing: 0) {
            // Search Bar - Stuck to the top
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
            .padding(.vertical, 8)
            .background(Color.white) // Ensure the search bar stays visible
            .zIndex(1) // Ensure it's above the scroll view

            // Saved Restaurants Section
            if viewModel.savedRestaurants.isEmpty {
                Spacer()
                Text("No saved restaurants")
                    .font(.montserrat(size: 16))
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.savedRestaurants) { restaurant in
                            RestaurantSearchCard(restaurant: restaurant)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10) // Prevents content from sticking under the search bar
                }
            }
        }
        .navigationTitle("Saved Restaurants")
        .onAppear {
            viewModel.fetchSavedRestaurants()
        }
    }
}
