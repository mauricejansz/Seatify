//
//  RestaurantDetailViewWrapper.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-24.
//
import SwiftUI

struct RestaurantDetailViewWrapper: View {
    let restaurantId: Int

    @State private var restaurant: Restaurant?

    var body: some View {
        Group {
            if let restaurant = restaurant {
                RestaurantDetailView(restaurant: restaurant)
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        fetchRestaurant()
                    }
            }
        }
    }

    func fetchRestaurant() {
        guard let token = KeychainHelper.retrieveToken(for: "accessToken"),
              let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/\(restaurantId)/") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(Restaurant.self, from: data) {
                    DispatchQueue.main.async {
                        restaurant = decoded
                    }
                }
            }
        }.resume()
    }
}
