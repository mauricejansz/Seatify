//
//  RestaurantCard.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-25.
//

import SwiftUI

struct RestaurantCard: View {
    let restaurant: Restaurant
    @State private var isBookmarked: Bool = false // Manage bookmark state
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Restaurant Image
            ZStack(alignment: .topTrailing) {
                if let image = restaurant.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill) // Fill the frame while maintaining aspect ratio
                        .frame(width: 250, height: 180) // Set a fixed width and height for uniformity
                        .clipped() // Ensure the image does not exceed the bounds
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 250, height: 180)
                        .overlay(Text("No Image").foregroundColor(.white))
                }
            }
            
            // Restaurant Details
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(restaurant.name)
                        .font(.montserrat(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Spacer()
                    Button(action: {
                        isBookmarked.toggle()
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
                    .fixedSize(horizontal: false, vertical: true) // Allows wrapping
                
                // Rating & Cuisine
                HStack {
                    Image("star")
                        .resizable()
                        .frame(width: 14, height: 14)
                    
                    Text(String(format: "%.1f", restaurant.rating))
                        .font(.montserrat(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(restaurant.cuisine)
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
    }
}

// MARK: - Preview with Sample Data
struct RestaurantCard_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = Restaurant(
            id: 1,
            name: "Culture Colombo",
            description: "A fine dining Sri Lankan restaurant in the heart of the city.",
            address: "25 Kensington Garden, Colombo 04, Colombo, Sri Lanka",
            phone: "0761234567",
            cuisine: "Sri Lankan",
            rating: 4.8,
            lowest_price: 500.0,
            highest_price: 2000.0,
            is_published: true,
            latitude: 6.9271,
            longitude: 79.8612,
            image_data: nil // No image for preview
        )
        
        return RestaurantCard(restaurant: sampleRestaurant)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
