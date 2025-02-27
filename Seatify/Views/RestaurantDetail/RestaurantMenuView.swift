//
//  RestaurantMenuView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI

struct RestaurantMenuView: View {
    let restaurantId: Int
    @StateObject private var viewModel = RestaurantMenuViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.menu.isEmpty {
                    Text("No menu available.")
                        .font(.montserrat(size: 16))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    let categories = viewModel.menu.keys.sorted()
                    ForEach(categories, id: \.self) { category in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(category)
                                .font(.montserrat(size: 18, weight: .bold))
                                .padding(.vertical, 5)
                                .foregroundColor(.black)
                            let items = viewModel.menu[category] ?? [] // Cache items first

                            VStack(spacing: 12) {
                                ForEach(items, id: \.id) { item in
                                    MenuItemView(menuItem: item)
                                    Divider()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 10)
        }
        .onAppear {
            viewModel.fetchMenu(for: restaurantId)
        }
    }
}

struct MenuItemView: View {
    let menuItem: MenuItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(menuItem.name)
                    .font(.montserrat(size: 16, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                if let price = Double(menuItem.price) {
                    Text("Rs \(price, specifier: "%.0f")")
                        .font(.montserrat(size: 16))
                        .foregroundColor(Color("PrimaryFont"))
                } else {
                    Text("Price unavailable")
                        .font(.montserrat(size: 16))
                        .foregroundColor(.red)
                }
            }
            Text(menuItem.description)
                .font(.montserrat(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
