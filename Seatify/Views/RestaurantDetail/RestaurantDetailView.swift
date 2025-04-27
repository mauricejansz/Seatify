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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(restaurant.name)
                        .font(.montserrat(size: 22, weight: .bold))
                        .foregroundColor(Color("PrimaryFont"))
                    
                    HStack {
                        Image("location")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text(restaurant.address)
                            .font(.montserrat(size: 14))
                            .foregroundColor(Color("PrimaryFont"))
                    }
                    
                    HStack {
                        Image("star")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text("\(String(format: "%.1f", restaurant.rating))")
                            .font(.montserrat(size: 14))
                            .foregroundColor(Color("PrimaryFont"))
                    }
                    
                    HStack {
                        Image("comment")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text("\(restaurant.review_count) \(restaurant.review_count == 1 ? "Review" : "Reviews")")
                            .font(.montserrat(size: 14))
                            .foregroundColor(Color("PrimaryFont"))
                    }
                    
                    HStack {
                        Text(restaurant.cuisine.name)
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
                
                if selectedTab == 0 {
                    RestaurantReservationTabView(restaurant: restaurant)
                } else if selectedTab == 1 {
                    RestaurantMenuTabView(restaurantId: restaurant.id)
                } else if selectedTab == 2 {
                    RestaurantReviewTabView(restaurantId: restaurant.id)
                } else if selectedTab == 3 {
                    restaurantDetailsView()
                }
            }
        }
        .navigationBarTitle(restaurant.name, displayMode: .inline)
        .background(Color("BackgroundColor"))
    }
    
    private func restaurantDetailsView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top, spacing: 6) {
                Image("description")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color("PrimaryFont"))
                
                Text(restaurant.description)
                    .font(.montserrat(size: 14))
                    .foregroundColor(Color("PrimaryFont"))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal)

            HStack {
                Image("location")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color("PrimaryFont"))
                Text(restaurant.address)
                    .font(.montserrat(size: 14))
                    .foregroundColor(Color("PrimaryFont"))
            }
            .padding(.horizontal)

            HStack {
                Image("phone")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color("PrimaryAccent"))
                if let phoneURL = URL(string: "tel://\(restaurant.phone)"), UIApplication.shared.canOpenURL(phoneURL) {
                    Link(restaurant.phone, destination: phoneURL)
                        .font(.montserrat(size: 14))
                        .foregroundColor(Color("PrimaryFont"))
                } else {
                    Text(restaurant.phone)
                        .font(.montserrat(size: 14))
                        .foregroundColor(Color("PrimaryFont"))
                }
            }
            .padding(.horizontal)

            HStack {
                Image("dollar")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color("PrimaryAccent"))
                Text("Rs. \(String(format: "%.0f", restaurant.lowest_price)) - Rs. \(String(format: "%.0f", restaurant.highest_price))")
                    .font(.montserrat(size: 14))
                    .foregroundColor(Color("PrimaryFont"))
            }
            .padding(.horizontal)

            RestaurantMapView(latitude: restaurant.latitude, longitude: restaurant.longitude, title: restaurant.name)
                .frame(height: 200)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

            Button(action: openGoogleMaps) {
                Text("Get Directions")
                    .font(.montserrat(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryAccent"))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()
        }
        .padding(.top, 10)
    }
    private func openGoogleMaps() {
        let latitude = restaurant.latitude
        let longitude = restaurant.longitude
        let urlString = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        
        if let googleMapsURL = URL(string: urlString), UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL)
        } else {
            if let webURL = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)") {
                UIApplication.shared.open(webURL)
            }
        }
    }
}
