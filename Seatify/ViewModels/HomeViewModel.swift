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
    
    func fetchRestaurants() {
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/") else { return }
        fetchData(from: url) { (decodedData: [Restaurant]?) in
            DispatchQueue.main.async {
                self.restaurants = decodedData ?? []
            }
        }
    }
    
    func fetchCuisines() {
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else { return }
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/cuisines/") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch cuisines:", error?.localizedDescription ?? "Unknown error")
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode([Cuisine].self, from: data)
                DispatchQueue.main.async {
                    self.cuisines = decodedResponse
                }
            } catch {
                print("Error decoding cuisines:", error)
            }
        }.resume()
    }
    
    private func fetchData<T: Decodable>(from url: URL, completion: @escaping (T?) -> Void) {
        var request = URLRequest(url: url)
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else { return }
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(decodedResponse)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
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
    
    func fetchRecentBookings() {
            guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else { return }
            guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/recent_bookings/") else { return }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Failed to fetch recent bookings:", error?.localizedDescription ?? "Unknown error")
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode([Restaurant].self, from: data)
                    DispatchQueue.main.async {
                        self.recentBookings = decodedResponse
                    }
                } catch {
                    print("Error decoding recent bookings:", error)
                }
            }.resume()
        }
    
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeychainHelper.retrieveToken(for: "refreshToken") else {
            print("No refresh token found, user needs to log in again.")
            completion(false)
            return
        }
        
        let url = URL(string: "\(AppConfig.backendURL)/accounts/api/token/refresh/")!
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
                    
                    // Fetch user info after token refresh
                    self.fetchUserInfo { success in
                        completion(success)
                    }
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
    
    func fetchUserInfo(completion: @escaping (Bool) -> Void) {
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else {
            completion(false)
            return
        }
        
        let url = URL(string: "\(AppConfig.backendURL)/accounts/api/user/")! // Adjust the API endpoint
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
