//
//  SignUpView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//

import SwiftUI

struct SignUpView: View {
    var onSignUp: () -> Void

    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dateOfBirth: Date = Date()
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showDatePicker = false
    @State private var navigateToVerify = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 50)

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.bottom, 20)

                Text("Welcome to Seatify")
                    .font(.montserrat(size: 24, weight: .bold))
                    .padding(.bottom, 5)

                Text("Sign up to start your journey")
                    .font(.montserrat(size: 14))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                ScrollView {
                    VStack(spacing: 16) {
                        TextField("Email Address", text: $email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color("InputFieldBackground"))
                            .cornerRadius(8)

                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color("InputFieldBackground"))
                            .cornerRadius(8)

                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color("InputFieldBackground"))
                            .cornerRadius(8)

                        SecureField("Confirm Password", text: $confirmPassword)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color("InputFieldBackground"))
                            .cornerRadius(8)

                        TextField("First Name", text: $firstName)
                            .padding()
                            .background(Color("InputFieldBackground"))
                            .cornerRadius(8)

                        TextField("Last Name", text: $lastName)
                            .padding()
                            .background(Color("InputFieldBackground"))
                            .cornerRadius(8)

                        TextField("DD/MM/YYYY", text: Binding(
                            get: {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                return formatter.string(from: dateOfBirth)
                            },
                            set: { newValue in
                                let numbers = newValue.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                                var formatted = ""

                                for (index, char) in numbers.enumerated() {
                                    if index == 2 || index == 4 {
                                        formatted += "/"
                                    }
                                    formatted.append(char)
                                }

                                if formatted.count > 10 {
                                    formatted = String(formatted.prefix(10))
                                }

                                if let date = DateFormatter.dateFromDDMMYYYY(formatted) {
                                    dateOfBirth = date
                                }
                            }
                        ))
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color("InputFieldBackground"))
                        .cornerRadius(8)
                        .foregroundColor(Color("TextColor"))

                        TextField("Phone Number", text: $phoneNumber)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color("InputFieldBackground"))
                            .cornerRadius(8)

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.montserrat(size: 14))
                                .padding(.horizontal, 20)
                        }

                        Button(action: {
                            registerUser()
                        }) {
                            if isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("PrimaryAccent"))
                                    .cornerRadius(10)
                            } else {
                                Text("Register")
                                    .font(.montserrat(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("PrimaryAccent"))
                                    .cornerRadius(10)
                                    .shadow(color: Color("PrimaryAccent").opacity(0.5), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)

                Spacer()

                HStack {
                    Text("Already have an account?")
                        .font(.montserrat(size: 14))
                        .foregroundColor(.gray)

                    Button(action: {
                        onSignUp()
                    }) {
                        Text("Login")
                            .font(.montserrat(size: 14, weight: .bold))
                            .foregroundColor(Color("PrimaryAccent"))
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(isPresented: $navigateToVerify) {
                VerifyEmailView(email: email, onVerified: {
                    onSignUp()
                })
            }
        }
    }

    private func registerUser() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "\(AppConfig.backendURL)/accounts/api/signup/") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: dateOfBirth)

        let body: [String: Any] = [
            "email": email,
            "username": username,
            "password": password,
            "confirm_password": confirmPassword,
            "first_name": firstName,
            "last_name": lastName,
            "date_of_birth": formattedDate,
            "phone_number": phoneNumber
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            errorMessage = "Failed to encode data"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "Invalid response"
                    return
                }

                if httpResponse.statusCode == 200 {
                    print("User registered successfully")
                    navigateToVerify = true
                } else if let data = data {
                    let errorResponse = String(data: data, encoding: .utf8) ?? "Unknown error"
                    errorMessage = "Error: \(errorResponse)"
                } else {
                    errorMessage = "Failed to register user"
                }
            }
        }.resume()
    }
}
