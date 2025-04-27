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
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/\(restaurantId)/reviews/") else { return }
        
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

    func addReview(for restaurantId: Int, rating: Double, comment: String) {
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/\(restaurantId)/create_review/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = KeychainHelper.retrieveToken(for: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let reviewData = ReviewRequest(rating: rating, comment: comment)
        
        do {
            request.httpBody = try JSONEncoder().encode(reviewData)
        } catch {
            print("Failed to encode review data: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to add review: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.fetchReviews(for: restaurantId) // Refresh reviews
            }
        }.resume()
    }

    func deleteReview(reviewId: Int, restaurantId: Int) {
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/delete_review/\(reviewId)/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let accessToken = KeychainHelper.retrieveToken(for: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Failed to delete review: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self.fetchReviews(for: restaurantId) // Refresh reviews
            }
        }.resume()
    }
}
