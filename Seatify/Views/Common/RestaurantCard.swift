//
//  RestaurantCard.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-25.
//

import SwiftUI

struct RestaurantCard: View {
    let restaurant: Restaurant
    @State private var isBookmarked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                if let image = restaurant.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 180)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 250, height: 180)
                        .overlay(Text("No Image").foregroundColor(.white))
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(restaurant.name)
                        .font(.montserrat(size: 18, weight: .bold))
                        .foregroundColor(Color("TextColor"))
                        .lineLimit(1)

                    Spacer()

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

                Text(restaurant.address)
                    .font(.montserrat(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)

                HStack {
                    Image("star")
                        .resizable()
                        .frame(width: 14, height: 14)

                    Text(String(format: "%.1f", restaurant.rating))
                        .font(.montserrat(size: 14, weight: .medium))
                        .foregroundColor(.black)

                    Spacer()

                    Text(restaurant.cuisine.name)
                        .font(.montserrat(size: 12))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color("SecondaryAccent"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onAppear {
            checkIfBookmarked()
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
