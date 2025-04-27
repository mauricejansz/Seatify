//
//  MainTabView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @Binding var isLoggedIn: Bool
    @Binding var showOnboarding: Bool
    @Binding var appState: AppState

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView(isLoggedIn: $isLoggedIn, showOnboarding: $showOnboarding, appState: $appState)
                    .tabItem {
                        VStack {
                            Image("home_menu")
                                .renderingMode(.template)
                            Text("Home")
                        }
                    }
                    .tag(0)
                
                SearchView(initialQuery: "")
                    .tabItem {
                        VStack {
                            Image("search_menu")
                                .renderingMode(.template)
                            Text("Search")
                        }
                    }
                    .tag(1)
                
                SavedView()
                    .tabItem {
                        VStack {
                            Image("bookmark_menu")
                                .renderingMode(.template)
                            Text("Saved")
                        }
                    }
                    .tag(2)
                
                ReservationsView()
                    .tabItem {
                        VStack {
                            Image("calendar_menu")
                                .renderingMode(.template)
                            Text("Reservations")
                        }
                    }
                    .tag(3)
            }
            .tint(Color("PrimaryAccent"))
        }
    }
}
