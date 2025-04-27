//
//  RestaurantSearchCard.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-05.
//

import SwiftUI

struct RestaurantSearchCard: View {
    let restaurant: Restaurant
    @State private var isBookmarked: Bool = false
    
    var body: some View {
        NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack{
                            Text(restaurant.name)
                                .font(.montserrat(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                            
                            // Bookmark Button
                            Button(action: {
                                toggleBookmark()
                            }) {
                                Image("bookmark")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(isBookmarked ? Color("PrimaryAccent") : Color("InactiveColor"))
                                    .padding(12)
                            }
                        }
                        
                        
                        HStack(spacing: 4) {
                            Image("location")
                                .resizable()
                                .frame(width: 12, height: 12)
                            Text(restaurant.address)
                                .font(.montserrat(size: 14))
                                .foregroundColor(Color("PrimaryFont"))
                                .lineLimit(1)
                        }
                        
                        HStack(spacing: 4) {
                            Image("directions")
                                .resizable()
                                .frame(width: 12, height: 12)
                            Text("5.2 km Away")
                                .font(.montserrat(size: 14))
                                .foregroundColor(Color("PrimaryFont"))
                        }
                        
                        HStack {
                            Image("star")
                                .resizable()
                                .frame(width: 12, height: 12)
                            Text(String(format: "%.1f", restaurant.rating))
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        HStack {
                            Text(restaurant.cuisine.name)
                                .font(.montserrat(size: 14))
                                .foregroundColor(Color("SecondaryAccent"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color("PrimaryAccent"))
                                .cornerRadius(99)
                        }
                    }
                    
                    
                }
                .padding()
                
                Divider()
                    .padding(.horizontal, 16)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            .onAppear {
                checkIfBookmarked()
            }
        }
    }
    private func toggleBookmark() {
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/saved/\(restaurant.id)/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let accessToken = KeychainHelper.retrieveToken(for: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    isBookmarked = true
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    isBookmarked = false
                }
            }
        }.resume()
    }
    private func checkIfBookmarked() {
        guard let accessToken = KeychainHelper.retrieveToken(for: "accessToken") else { return }
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/saved/") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data {
                do {
                    let savedRestaurants = try JSONDecoder().decode([SavedRestaurant].self, from: data)
                    DispatchQueue.main.async {
                        isBookmarked = savedRestaurants.contains { $0.restaurant == restaurant.id }
                    }
                } catch {
                    print("Failed to decode saved restaurants")
                }
            }
        }.resume()
    }
}
