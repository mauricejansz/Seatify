//
//  SavedView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-26.
//

import SwiftUI

struct SavedView: View {
    @StateObject private var viewModel = SavedViewModel()

    var body: some View {
        VStack {
            if viewModel.savedRestaurants.isEmpty {
                VStack {
                    Spacer()
                    Text("No saved restaurants")
                        .font(.montserrat(size: 16))
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.savedRestaurants) { restaurant in
                            RestaurantSearchCard(restaurant: restaurant)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
        }
        .navigationTitle("Saved Restaurants")
        .onAppear {
            viewModel.fetchSavedRestaurants()
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
}
