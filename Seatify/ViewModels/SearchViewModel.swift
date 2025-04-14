////
////  SearchViewModel.swift
////  Seatify
////
////  Created by Maurice Jansz on 2025-03-06.
////
//
//
//import Foundation
//
//class SearchViewModel: ObservableObject {
//    @Published var allRestaurants: [Restaurant] = []
//    @Published var filteredRestaurants: [Restaurant] = []
//    @Published var searchText: String = ""
//
//    init() {
//        fetchAllRestaurants()
//    }
//
//    func fetchAllRestaurants() {
//        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else {
//            print("Access token missing")
//            return
//        }
//
//        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/") else { return }
//        
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                do {
//                    let decodedResponse = try JSONDecoder().decode([Restaurant].self, from: data)
//                    DispatchQueue.main.async {
//                        self.allRestaurants = decodedResponse
//                        self.filteredRestaurants = decodedResponse // Initially show all
//                    }
//                } catch {
//                    print("Error decoding restaurants: \(error)")
//                }
//            } else if let error = error {
//                print("Network request failed: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
//
////    func filterRestaurants() {
////        if searchText.isEmpty {
////            filteredRestaurants = allRestaurants
////        } else {
////            filteredRestaurants = allRestaurants.filter { restaurant in
////                let matchesName = restaurant.name.lowercased().contains(searchText.lowercased())
////                let matchesCuisine = restaurant.cuisine.lowercased().contains(searchText.lowercased())
////                let matchesMenu = restaurant.menuItems.contains { item in
////                    item.name.lowercased().contains(searchText.lowercased())
////                }
////                return matchesName || matchesCuisine || matchesMenu
////            }
////        }
////    }
//}
