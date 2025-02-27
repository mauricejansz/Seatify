//
//  RestaurantDetailView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-25.
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @State private var selectedTab: Int = 0
    
    var body: some View {
            
        ScrollView {
            VStack(alignment: .leading) {
                if let image = restaurant.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(Text("No Image").foregroundColor(.white))
                }
                
                // 🔹 Restaurant Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(restaurant.name)
                        .font(.montserrat(size: 22, weight: .bold))
                    
                    HStack {
                        Image("location")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text(restaurant.address)
                            .font(.montserrat(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Image("star")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(String(format: "%.1f", restaurant.rating))") // Placeholder
                            .font(.montserrat(size: 14))
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Image("comment")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(String(format: "%.0f", restaurant.rating)) Reviews") // Placeholder
                            .font(.montserrat(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text(restaurant.cuisine)
                            .font(.montserrat(size: 14))
                            .foregroundColor(Color("SecondaryAccent"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color("PrimaryAccent"))
                            .cornerRadius(99)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                RestaurantTabView(selectedTab: $selectedTab)
                
                Divider()
                
                // Render respective tab content
                if selectedTab == 0 {
                    RestaurantReservationView(restaurant: restaurant)
                } else if selectedTab == 1 {
                    RestaurantMenuView(restaurantId: restaurant.id)
                } else if selectedTab == 2 {
                    RestaurantReviewView(restaurantId: restaurant.id)
                } else if selectedTab == 3 {
                    Text("📜 Details - Coming Soon...")
                        .font(.montserrat(size: 18))
                        .padding()
                }
            }
        }
        .navigationBarTitle(restaurant.name, displayMode: .inline)
    }
}
