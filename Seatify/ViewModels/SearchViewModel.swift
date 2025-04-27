//
//  SearchViewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-06.
//
import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var query: String {
        didSet {
            filterResults()
        }
    }
    @Published var allRestaurants: [Restaurant] = []
    @Published var cuisines: [Cuisine] = []
    @Published var filteredRestaurants: [Restaurant] = []

    init(initialQuery: String? = nil) {
        self.query = initialQuery ?? ""
    }
    
    func fetchSearchData() {
        guard let token = KeychainHelper.retrieveToken(for: "accessToken") else { return }
        
        if let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([Restaurant].self, from: data) {
                    DispatchQueue.main.async {
                        self.allRestaurants = decoded
                        self.filterResults()
                    }
                }
            }.resume()
        }
        
        if let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/cuisines/") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([Cuisine].self, from: data) {
                    DispatchQueue.main.async {
                        self.cuisines = decoded
                        self.filterResults()
                    }
                }
            }.resume()
        }
    }

    private func filterResults() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.isEmpty {
            filteredRestaurants = allRestaurants
            return
        }

        filteredRestaurants = allRestaurants.filter { restaurant in
            let restaurantName = restaurant.name.lowercased()
            let cuisineName = restaurant.cuisine.name.lowercased()
            
            let matchedCuisine = restaurant.cuisine.name.lowercased().contains(trimmed)
                || restaurant.cuisine.keyword.lowercased().contains(trimmed)

            let menuMatches = restaurant.menu_categories.contains { category in
                category.category.lowercased().contains(trimmed) ||
                category.items.contains { item in
                    item.name.lowercased().contains(trimmed) ||
                    item.description.lowercased().contains(trimmed)
                }
            }

            return restaurantName.contains(trimmed)
                || cuisineName.contains(trimmed)
                || matchedCuisine
                || menuMatches
        }
    }
    func triggerFilterManually() {
        filterResults()
    }
}
