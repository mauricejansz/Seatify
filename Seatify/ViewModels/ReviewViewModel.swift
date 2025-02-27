//
//  ReviewViewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import Foundation

class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var averageRating: Double = 0.0
    @Published var isLoading = false
    
    func fetchReviews(for restaurantId: Int) {
        guard let url = URL(string: "http://localhost:8000/api/restaurants/\(restaurantId)/reviews/") else { return }
        
        isLoading = true
        var request = URLRequest(url: url)
        if let accessToken = KeychainHelper.retrieveToken(for: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            guard let data = data, error == nil else {
                print("Failed to fetch reviews: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode([Review].self, from: data)
                DispatchQueue.main.async {
                    self.reviews = decodedResponse
                    self.averageRating = decodedResponse.map { $0.rating }.reduce(0, +) / Double(decodedResponse.count)
                }
            } catch {
                print("Error decoding review data: \(error)")
            }
        }.resume()
    }
}
