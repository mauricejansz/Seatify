//
//  HomeView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-23.
//

import SwiftUI

struct HomeView: View {
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? "User"
    @Binding var isLoggedIn: Bool
    @Binding var showOnboarding: Bool
    @Binding var appState: AppState
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Good Evening, \(username)!")
                        .font(.montserrat(size: 20, weight: .bold))
                        .padding(.leading, 20)
                    Spacer()
                    NavigationLink(destination: UserProfileView(isLoggedIn: $isLoggedIn, appState: $appState)) {
                        Image("user")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.top, 40)
                .onAppear {
                    if let savedUsername = UserDefaults.standard.string(forKey: "username") {
                        username = savedUsername
                    }
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                    
                        // Restaurants Scroll View
                        Text("Browse by Restaurant")
                            .font(.montserrat(size: 18, weight: .bold))
                            .padding(.leading)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                if viewModel.restaurants.isEmpty {
                                    Text("No restaurants available")
                                        .font(.montserrat(size: 16))
                                        .foregroundColor(.gray)
                                        .padding()
                                } else {
                                    ForEach(viewModel.restaurants) { restaurant in
                                        NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                            RestaurantCard(restaurant: restaurant)
                                                .frame(width: 250, height: 320)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 370)

                        // Browse by Cuisine Section
                        Text("Browse by Cuisine")
                            .font(.montserrat(size: 18, weight: .bold))
                            .padding(.leading)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.cuisines) { cuisine in
                                    VStack {
                                        if let uiImage = cuisine.image {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                                .shadow(radius: 3)
                                        } else {
                                            Circle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 80, height: 80)
                                                .overlay(Text("No Image").foregroundColor(.white))
                                        }
                                        
                                        Text(cuisine.name)
                                            .font(.montserrat(size: 14))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Recent Bookings Section
                        if !viewModel.recentBookings.isEmpty {
                            Text("Recent Bookings")
                                .font(.montserrat(size: 18, weight: .bold))
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.recentBookings) { restaurant in
                                        NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                            RestaurantCard(restaurant: restaurant)
                                                .frame(width: 250, height: 320)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 370)
                        }
                    }
                    .padding(.bottom, 20) // Ensure spacing at bottom
                }
                .frame(height: geometry.size.height - 180) // Set max height for the scroll view
            }
        }
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.fetchRestaurants()
            viewModel.fetchCuisines()
            viewModel.fetchRecentBookings()
        }
    }
}

// MARK: - Updated Preview with Mock Data
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel()
        viewModel.restaurants = [
            Restaurant(
                id: 1,
                name: "Culture Colombo",
                description: "A fine dining Sri Lankan restaurant in the heart of the city.",
                address: "25 Kensington Garden, Colombo 04",
                phone: "0761234567",
                cuisine: "Sri Lankan",
                rating: 4.8,
                lowest_price: 500.0,
                highest_price: 2000.0,
                is_published: true,
                latitude: 6.9271,
                longitude: 79.8612,
                image_data: nil,
                review_count: 5
            ),
            Restaurant(
                id: 2,
                name: "Giovanni's",
                description: "Authentic Italian thin-crust pizza baked in a wood-fired oven.",
                address: "145 Thimbirigasyaya Rd, Colombo 05",
                phone: "0762623224",
                cuisine: "Italian",
                rating: 4.6,
                lowest_price: 800.0,
                highest_price: 3000.0,
                is_published: true,
                latitude: 6.9244,
                longitude: 79.8643,
                image_data: nil,
                review_count: 20
            )
        ]
        
        return HomeView(
            isLoggedIn: .constant(false),
            showOnboarding: .constant(false),
            appState: .constant(.home)
        )
        .environmentObject(viewModel) // Inject ViewModel with mock data
        .previewLayout(.device)
    }
}
