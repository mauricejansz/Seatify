//
//  UserProfileView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-26.
//

import SwiftUI

struct UserProfileView: View {
    @Binding var isLoggedIn: Bool
    @Binding var appState: AppState
    @Environment(\.dismiss) var dismiss  // Used to dismiss the modal

    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .padding()
            
            Text("Maurice Jansz")
                .font(.montserrat(size: 20, weight: .bold))
                .padding(.top, 10)
            
            Button(action: {
                logoutUser()
            }) {
                Text("Logout")
                    .font(.montserrat(size: 18, weight: .bold))
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.red.opacity(0.5), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.all)
    }
    
    private func logoutUser() {
        print("Logging out user...")
        print("Stored username before logout: \(UserDefaults.standard.string(forKey: "username") ?? "None")")
        
        KeychainHelper.deleteToken(for: "accessToken")
        KeychainHelper.deleteToken(for: "refreshToken")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "username")
        
        // Use a slight delay to ensure state updates then dismiss the view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isLoggedIn = false
            appState = .login  // This will make your ContentView show LoginView
            dismiss()        // Dismiss the modal view
        }
        
        print("Logout complete. App state updated to login.")
    }
}
