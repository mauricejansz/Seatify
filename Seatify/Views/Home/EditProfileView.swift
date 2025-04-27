//
//  EditProfileView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-24.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var phoneNumber = ""
    @State private var isSaving = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Username", text: $username)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }

                if let error = errorMessage {
                    Text(error).foregroundColor(.red)
                }

                Button(action: updateProfile) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Save Changes")
                    }
                }
                .font(.montserrat(size: 14, weight: .bold))
                .foregroundColor(Color("PrimaryAccent"))
            }
            .navigationTitle("Edit Profile")
            .onAppear(perform: loadUserData)
            
        }
        .background(Color("BackgroundColor"))
    }

    func loadUserData() {
        firstName = UserDefaults.standard.string(forKey: "first_name") ?? ""
        lastName = UserDefaults.standard.string(forKey: "last_name") ?? ""
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        phoneNumber = UserDefaults.standard.string(forKey: "phone_number") ?? ""
    }

    func updateProfile() {
        guard let url = URL(string: "\(AppConfig.backendURL)/accounts/api/update_profile/") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken = KeychainHelper.retrieveToken(for: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let body: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "username": username,
            "phone_number": phoneNumber
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        isSaving = true
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSaving = false

                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    errorMessage = "Failed to update profile."
                    return
                }

                UserDefaults.standard.set(firstName, forKey: "first_name")
                UserDefaults.standard.set(lastName, forKey: "last_name")
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(phoneNumber, forKey: "phone_number")

                dismiss()
            }
        }.resume()
    }
}
