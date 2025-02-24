//
//  HomeViewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []

    func fetchRestaurants() {
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else {
            print("Access token missing, attempting refresh...")
            refreshAccessToken { success in
                if success {
                    self.fetchRestaurants() // Retry fetching after token refresh
                } else {
                    print("Failed to refresh token, user may need to re-login.")
                }
            }
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8000/api/restaurants/") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)") // Debugging
            }

            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Restaurant].self, from: data)
                    DispatchQueue.main.async {
                        self.restaurants = decodedResponse
                    }
                } catch {
                    print("Error decoding restaurants: \(error)")
                }
            } else if let error = error {
                print("Network request failed: \(error.localizedDescription)")
            }
        }.resume()
    }

    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeychainHelper.retrieveToken(for: "refreshToken") else {
            print("No refresh token found, user needs to log in again.")
            completion(false)
            return
        }

        let url = URL(string: "http://localhost:8000/accounts/api/token/refresh/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["refresh": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Token refresh failed: \(String(describing: error?.localizedDescription))")
                completion(false)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let newAccessToken = json["access"] as? String {
                    
                    // Store the new access token
                    KeychainHelper.storeToken(newAccessToken, key: "accessToken")
                    print("Access token refreshed successfully.")
                    completion(true)
                } else {
                    print("Failed to parse refresh token response.")
                    completion(false)
                }
            } catch {
                print("JSON decoding error: \(error)")
                completion(false)
            }
        }.resume()
    }
}
