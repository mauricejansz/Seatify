//
//  RestaurantDetailViewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI

class RestaurantDetailViewModel: ObservableObject {
    @Published var availableSlots: [SlotResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchAvailableSlots(for restaurantId: Int, guests: Int, date: Date) {
        isLoading = true
        errorMessage = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/\(restaurantId)/slots/?guests=\(guests)&date=\(formattedDate)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        if let accessToken = KeychainHelper.retrieveToken(for: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                do {
                    let decodedSlots = try JSONDecoder().decode([SlotResponse].self, from: data)
                    self.availableSlots = decodedSlots
                } catch {
                    self.errorMessage = "Failed to decode response"
                }
            }
        }.resume()
    }
}

