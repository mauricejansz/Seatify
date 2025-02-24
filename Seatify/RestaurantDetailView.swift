//
//  RestaurantDetailView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-25.
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let image = restaurant.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 150, height: 150)
                                    .overlay(Text("No Image").foregroundColor(.white))
                            }

                Text(restaurant.name)
                    .font(.montserrat(size: 24, weight: .bold))
                    .padding(.top, 10)

                Text(restaurant.address)
                    .font(.montserrat(size: 16))
                    .foregroundColor(.gray)

                HStack {
                    Text("⭐ \(String(format: "%.1f", restaurant.rating))")
                        .font(.montserrat(size: 16))
                        .foregroundColor(.yellow)

                    Spacer()

                    Text(restaurant.cuisine)
                        .font(.montserrat(size: 16))
                        .padding(5)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(5)
                }
                .padding(.top, 5)

                Text("Price Range: \(String(format: "$%.2f - $%.2f", restaurant.lowest_price, restaurant.highest_price))")
                    .font(.montserrat(size: 16))
                    .padding(.top, 5)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle(restaurant.name, displayMode: .inline)
    }
}
