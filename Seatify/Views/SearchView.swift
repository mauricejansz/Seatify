//
//  SearchView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedRestaurant: Restaurant? = nil
    @State private var navigateToMap = false
    var initialQuery: String

    init(initialQuery: String) {
        _viewModel = StateObject(wrappedValue: SearchViewModel(initialQuery: initialQuery))
        self.initialQuery = initialQuery
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $viewModel.query)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .foregroundColor(Color("TextColor"))
                }
                .padding(10)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("PrimaryFont"), lineWidth: 1))

                Button {
                    navigateToMap = true
                } label: {
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Color("PrimaryAccent"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            if viewModel.filteredRestaurants.isEmpty {
                Spacer()
                Text("No results found")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.filteredRestaurants) { restaurant in
                            RestaurantSearchCard(restaurant: restaurant)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.query = initialQuery
            viewModel.fetchSearchData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewModel.triggerFilterManually()
            }
        }
        .background(Color("BackgroundColor"))
        .navigationDestination(isPresented: $navigateToMap) {
            RestaurantMapListView(
                restaurants: viewModel.filteredRestaurants
            )
        }
    }
}
