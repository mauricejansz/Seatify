//
//  HomeViewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var savedRestaurantIds: Set<Int> = []
    @Published var recentBookings: [Restaurant] = []
    @Published var cuisines: [Cuisine] = []

    func fetchAllData() {
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else { return }
        let group = DispatchGroup()

        group.enter()
        if let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, _ in
                defer { group.leave() }
                if let data = data {
                    if let decoded = try? JSONDecoder().decode([Restaurant].self, from: data) {
                        DispatchQueue.main.async {
                            self.restaurants = decoded
                        }
                    }
                }
            }.resume()
        }

        // Fetch Cuisines
        group.enter()
        if let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/cuisines/") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, _ in
                defer { group.leave() }
                if let data = data {
                    if let decoded = try? JSONDecoder().decode([Cuisine].self, from: data) {
                        DispatchQueue.main.async {
                            self.cuisines = decoded
                        }
                    }
                }
            }.resume()
        }

        group.enter()
        if let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/recent_bookings/") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, _, _ in
                defer { group.leave() }
                if let data = data {
                    if let decoded = try? JSONDecoder().decode([Restaurant].self, from: data) {
                        DispatchQueue.main.async {
                            self.recentBookings = decoded
                        }
                    }
                }
            }.resume()
        }
    }

    func fetchSavedRestaurants() {
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else { return }
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/saved/") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                do {
                    let savedRestaurants = try JSONDecoder().decode([SavedRestaurant].self, from: data)
                    DispatchQueue.main.async {
                        self.savedRestaurantIds = Set(savedRestaurants.map { $0.restaurant })
                    }
                } catch {
                    print("Failed to decode saved restaurants")
                }
            }
        }.resume()
    }

    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeychainHelper.retrieveToken(for: "refreshToken") else {
            print("No refresh token found.")
            completion(false)
            return
        }

        let url = URL(string: "\(AppConfig.backendURL)/accounts/api/token/refresh/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["refresh": refreshToken]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Token refresh failed.")
                completion(false)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let newAccessToken = json["access"] as? String {
                    KeychainHelper.storeToken(newAccessToken, key: "accessToken")
                    self.fetchUserInfo(completion: completion)
                } else {
                    completion(false)
                }
            } catch {
                print("Error decoding token refresh response.")
                completion(false)
            }
        }.resume()
    }

    func fetchUserInfo(completion: @escaping (Bool) -> Void) {
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else {
            completion(false)
            return
        }

        let url = URL(string: "\(AppConfig.backendURL)/accounts/api/user/")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(false)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let username = json["username"] as? String {
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.synchronize()
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }.resume()
    }
}
