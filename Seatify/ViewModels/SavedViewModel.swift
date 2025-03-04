//
//  SavedViewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-05.
//

import Foundation

class SavedViewModel: ObservableObject {
    @Published var savedRestaurants: [Restaurant] = []

    func fetchSavedRestaurants() {
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else {
            print("Access token missing")
            return
        }

        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/saved/details/") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("📜 Raw JSON Response: \(jsonString)")
                    }
                    let decodedResponse = try JSONDecoder().decode([Restaurant].self, from: data)
                    DispatchQueue.main.async {
                        self.savedRestaurants = decodedResponse
                    }
                } catch {
                    print("Error decoding saved restaurants: \(error)")
                }
            } else if let error = error {
                print("Network request failed: \(error.localizedDescription)")
            }
        }.resume()
    }
}
