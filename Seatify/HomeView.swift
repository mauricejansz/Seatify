//
//  HomeView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-23.
//

import SwiftUI

struct HomeView: View {
    var username: String
    @Binding var isLoggedIn: Bool
    @Binding var showOnboarding: Bool
    @Binding var appState: AppState
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("Good Evening, \(username)!")
                        .font(.montserrat(size: 20, weight: .bold))
                        .padding(.leading, 20)
                    Spacer()
                    Image("user")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 20)
                }
                .padding(.top, 40)
                
                
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
                                        .frame(width: 250, height: 320) // Ensure a fixed height
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 370)
                
                Spacer()
                
                // Footer Navigation Bar
                HStack {
                    Spacer()
                    VStack {
                        Image("home")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Home")
                            .font(.montserrat(size: 12))
                    }
                    Spacer()
                    VStack {
                        Image("search")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Search")
                            .font(.montserrat(size: 12))
                    }
                    Spacer()
                    VStack {
                        Image("bookmark")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Saved")
                            .font(.montserrat(size: 12))
                    }
                    Spacer()
                    VStack {
                        Image("calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Reservations")
                            .font(.montserrat(size: 12))
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
            }
            .background(Color("BackgroundColor"))
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                viewModel.fetchRestaurants()
            }
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
                image_data: nil
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
                image_data: nil
            )
        ]
        
        return HomeView(
            username: "Maurice",
            isLoggedIn: .constant(false),
            showOnboarding: .constant(false),
            appState: .constant(.home)
        )
        .environmentObject(viewModel) // Inject ViewModel with mock data
        .previewLayout(.device)
    }
}
