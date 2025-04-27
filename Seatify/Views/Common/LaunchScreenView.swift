//
//  LaunchScreenView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//
import SwiftUI

struct LaunchScreenView: View {
    var onLaunchComplete: (AppState) -> Void

    var body: some View {
        VStack {
            Spacer()
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding()
            Spacer()
        }
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                determineAppState()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Color.clear.frame(height: 20)
        }
    }

    private func determineAppState() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            onLaunchComplete(.onboarding)
        } else if let accessToken = KeychainHelper.retrieveToken(for: "accessToken") {
            validateToken(accessToken: accessToken) { isValid in
                DispatchQueue.main.async {
                    onLaunchComplete(isValid ? .home : .login)
                }
            }
        } else {
            onLaunchComplete(.login)
        }
    }

    private func validateToken(accessToken: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(AppConfig.backendURL)/accounts/api/validate-token/") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}


