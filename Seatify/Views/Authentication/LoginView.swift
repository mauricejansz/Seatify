//
//  LoginView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//

import SwiftUI

struct LoginView: View {
    var onRegister: () -> Void
    var onLoginSuccess: (String) -> Void // Pass username upon success

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String? = nil // To show error messages

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 50)

                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 110)
                    .padding()

                Text("Welcome to Seatify")
                    .font(.montserrat(size: 20, weight: .bold))
                    .padding(.top, 10)

                Text("Login to continue your Journey")
                    .font(.montserrat(size: 14))
                    .foregroundColor(.gray)

                Spacer()

                // Form Fields
                Group {
                    TextField("Email Address", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color("InputFieldBackground"))
                        .cornerRadius(8)
                        .foregroundColor(Color("TextColor"))

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color("InputFieldBackground"))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)

                // Show Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.montserrat(size: 14))
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }

                // Login Button
                Button(action: {
                    loginUser()
                }) {
                    Text("Login")
                        .font(.montserrat(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryAccent"))
                        .cornerRadius(10)
                        .shadow(color: Color("PrimaryAccent").opacity(0.5), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()

                // Register Link
                HStack {
                    Text("Don’t have an account?")
                        .font(.montserrat(size: 14))
                        .foregroundColor(.gray)

                    Button(action: {
                        onRegister()
                    }) {
                        Text("Register")
                            .font(.montserrat(size: 14, weight: .bold))
                            .foregroundColor(Color("PrimaryAccent"))
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color.white)
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func loginUser() {
        guard let url = URL(string: "\(AppConfig.backendURL)/accounts/api/login/") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "identifier": email,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid credentials or server error"
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let user = json["user"] as? [String: Any],
                   let username = user["username"] as? String,
                   let accessToken = json["access"] as? String,
                   let refreshToken = json["refresh"] as? String {
                    
                    // Store tokens
                    KeychainHelper.storeToken(accessToken, key: "accessToken")
                    KeychainHelper.storeToken(refreshToken, key: "refreshToken")

                    // Store username
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.synchronize()

                    DispatchQueue.main.async {
                        onLoginSuccess(username) // Pass username to HomeView
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "Failed to parse response"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to parse response"
                }
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            onRegister: {},
            onLoginSuccess: { _ in } // Provide a dummy closure for the preview
        )
    }
}
