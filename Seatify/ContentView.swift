//
//  ContentView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//

import SwiftUI

struct ContentView: View {
    @State private var appState: AppState = .launchScreen
    @State private var username: String = ""
    @State private var isLoggedIn = false
    @State private var showOnboarding = false

    var body: some View {
        ZStack {
            switch appState {
            case .launchScreen:
                LaunchScreenView { newState in
                    appState = newState
                }
            case .onboarding:
                OnboardingView(onGetStarted: {
                    UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                    appState = .login
                })
            case .login:
                LoginView(
                    onRegister: {
                        appState = .signUp
                    },
                    onLoginSuccess: { loggedInUsername in
                        username = loggedInUsername
                        appState = .home
                    }
                )
            case .home:
                HomeView(
                    username: username,
                    isLoggedIn: $isLoggedIn,
                    showOnboarding: $showOnboarding,
                    appState: $appState
                )
            case .signUp:
                SignUpView(
                    onSignUp: {
                        appState = .login
                    }
                )
            }
            
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
