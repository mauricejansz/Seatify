//
//  LoginView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//

import SwiftUI

struct LoginView: View {
    var onRegister: () -> Void
    var onLoginSuccess: (String) -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String? = nil
    @StateObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 110)
                        .padding(.top, 40)
                    
                    Text("Welcome to Seatify")
                        .font(.montserrat(size: 20, weight: .bold))
                    
                    Text("Login to continue your Journey")
                        .font(.montserrat(size: 14))
                        .foregroundColor(.gray)
                    
                    Group {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email Address")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            
                            TextField("", text: $email)
                                .textContentType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color("InputFieldBackground"))
                                .cornerRadius(8)
                                .foregroundColor(Color("TextColor"))
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            
                            SecureField("", text: $password)
                                .padding()
                                .background(Color("InputFieldBackground"))
                                .cornerRadius(8)
                                .foregroundColor(Color("TextColor"))
                        }
                    }
                    .padding(.horizontal)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.montserrat(size: 14))
                            .padding(.top, 5)
                    }
                    
                    Button(action: loginUser) {
                        Text("Login")
                            .font(.montserrat(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryAccent"))
                            .cornerRadius(10)
                            .shadow(color: Color("PrimaryAccent").opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack {
                        Text("Don’t have an account?")
                            .font(.montserrat(size: 14))
                            .foregroundColor(.gray)
                        
                        Button(action: onRegister) {
                            Text("Register")
                                .font(.montserrat(size: 14, weight: .bold))
                                .foregroundColor(Color("PrimaryAccent"))
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding()
                .padding(.bottom, keyboard.currentHeight)
                .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.white)
        }
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
                    
                    let firstName = user["first_name"] as? String ?? ""
                    let lastName = user["last_name"] as? String ?? ""
                    let phoneNumber = user["phone_number"] as? String ?? ""
                    
                    KeychainHelper.storeToken(accessToken, key: "accessToken")
                    KeychainHelper.storeToken(refreshToken, key: "refreshToken")
                    
                    UserDefaults.standard.set(firstName, forKey: "first_name")
                    UserDefaults.standard.set(lastName, forKey: "last_name")
                    UserDefaults.standard.set(phoneNumber, forKey: "phone_number")
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        onLoginSuccess(username)
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
