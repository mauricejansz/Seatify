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
    @Environment(\.dismiss) var dismiss
    @State private var showEditProfile = false
    @State private var showAbout = false
    @State private var showTerms = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)

            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("PrimaryAccent"))

            Text("Maurice Jansz")
                .font(.montserrat(size: 18, weight: .bold))

            Group {
                NavigationLink(destination: EditProfileView(), isActive: $showEditProfile) {
                    EmptyView()
                }
                ButtonView(label: "Edit Profile", systemImage: "square.and.pencil") {
                    showEditProfile = true
                }

                ButtonView(label: "About Us", systemImage: "info.circle") {
                    showAbout = true
                }
                .sheet(isPresented: $showAbout) {
                    AboutUsView()
                }

                ButtonView(label: "Terms & Conditions", systemImage: "doc.text") {
                    showTerms = true
                }
                .sheet(isPresented: $showTerms) {
                    TermsView()
                }
            }

            Spacer()

            Button(action: logoutUser) {
                Text("Logout")
                    .font(.montserrat(size: 16, weight: .bold))
                    .foregroundColor(Color("PrimaryAccent"))
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color.white)
        .navigationTitle("User Page")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func logoutUser() {
        KeychainHelper.deleteToken(for: "accessToken")
        KeychainHelper.deleteToken(for: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "username")
        isLoggedIn = false
        appState = .login
        dismiss()
    }
}
