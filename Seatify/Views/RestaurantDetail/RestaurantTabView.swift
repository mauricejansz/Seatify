//
//  RestaurantTabView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI

struct RestaurantTabView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            TabButton(title: "Reserve", isSelected: selectedTab == 0) { selectedTab = 0 }
            TabButton(title: "Menu", isSelected: selectedTab == 1) { selectedTab = 1 }
            TabButton(title: "Reviews", isSelected: selectedTab == 2) { selectedTab = 2 }
            TabButton(title: "Details", isSelected: selectedTab == 3) { selectedTab = 3 }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

