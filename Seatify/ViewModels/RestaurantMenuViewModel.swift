//
//  RestaurantMenuViewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//


import Foundation

class RestaurantMenuViewModel: ObservableObject {
    @Published var menu: [String: [MenuItem]] = [:] // Grouped by category
    @Published var isLoading = false

    func fetchMenu(for restaurantId: Int) {
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/\(restaurantId)/menu/") else {
            print("❌ Invalid URL")
            return
        }

        isLoading = true
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // ✅ Retrieve stored authentication token
        if let token = KeychainHelper.retrieveToken(for: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("❌ No access token found")
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                print("❌ Failed to fetch menu: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 403 {
                    print("❌ Unauthorized request: Check authentication token")
                    return
                }
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📜 Raw JSON Response: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode([MenuCategory].self, from: data)
                DispatchQueue.main.async {
                    self.menu = Dictionary(uniqueKeysWithValues: decodedResponse.map { ($0.category, $0.items) })
                }
            } catch let decodingError as DecodingError {
                print("❌ Decoding Error: \(decodingError)")
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("🔍 Type Mismatch: \(type), Context: \(context)")
                case .keyNotFound(let key, let context):
                    print("🔍 Key Not Found: \(key), Context: \(context)")
                case .valueNotFound(let type, let context):
                    print("🔍 Value Not Found: \(type), Context: \(context)")
                case .dataCorrupted(let context):
                    print("🔍 Data Corrupted: \(context)")
                default:
                    print("🔍 Unknown Decoding Error")
                }
            } catch {
                print("❌ Unexpected Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

