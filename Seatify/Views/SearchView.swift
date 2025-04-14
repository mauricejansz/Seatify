//
//  SearchView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-26.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        Text("SearchView")
    }
//    @StateObject private var viewModel = SearchViewModel()
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // Search Bar - Stuck to the top
//            HStack {
//                TextField("Search restaurants...", text: $viewModel.searchText, onEditingChanged: { _ in
//                    viewModel.filterRestaurants()
//                })
//                .padding(10)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//                .padding(.leading, 10)
//
//                Button(action: {
//                    viewModel.filterRestaurants()
//                }) {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.gray)
//                        .padding(.trailing, 10)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 8)
//            .background(Color.white)
//            .zIndex(1)
//
//            // Display filtered restaurants
//            if viewModel.filteredRestaurants.isEmpty {
//                Spacer()
//                Text("No restaurants found")
//                    .font(.montserrat(size: 16))
//                    .foregroundColor(.gray)
//                    .padding()
//                Spacer()
//            } else {
//                ScrollView {
//                    VStack(spacing: 10) {
//                        ForEach(viewModel.filteredRestaurants) { restaurant in
//                            RestaurantSearchCard(restaurant: restaurant)
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 10)
//                }
//            }
//        }
//        .navigationTitle("Search")
//    }
}
