//
//  HomeView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-23.
//

import SwiftUI

struct HomeView: View {
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? "User"
    @State private var first_name: String = UserDefaults.standard.string(forKey: "first_name") ?? "User"
    @Binding var isLoggedIn: Bool
    @Binding var showOnboarding: Bool
    @Binding var appState: AppState
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Good Evening, \(first_name)!")
                        .font(.montserrat(size: 20, weight: .bold))
                        .padding(.leading, 20)
                        .foregroundColor(Color("TextColor"))
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
                    
                        Text("Browse by Restaurant")
                            .font(.montserrat(size: 18, weight: .bold))
                            .padding(.leading)
                            .foregroundColor(Color("TextColor"))

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

                        Text("Browse by Cuisine")
                            .font(.montserrat(size: 18, weight: .bold))
                            .padding(.leading)
                            .foregroundColor(Color("TextColor"))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.cuisines) { cuisine in
                                    NavigationLink(destination: SearchView(initialQuery: cuisine.name)) {
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
                                                .foregroundColor(Color("TextColor"))
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        if !viewModel.recentBookings.isEmpty {
                            Text("Recent Bookings")
                                .font(.montserrat(size: 18, weight: .bold))
                                .padding(.leading)
                                .foregroundColor(Color("TextColor"))
                            
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
                    .padding(.bottom, 20)
                }
                .frame(height: geometry.size.height - 180)
            }
        }
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.fetchAllData()
        }
    }
}
