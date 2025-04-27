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
    @StateObject private var keyboard = KeyboardResponder()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 30)

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .padding(.bottom, 10)

                    Text("Welcome to Seatify")
                        .font(.montserrat(size: 24, weight: .bold))

                    Text("Sign up to start your journey")
                        .font(.montserrat(size: 14))
                        .foregroundColor(.gray)

                    Group {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email Address")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            TextField("", text: $email)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color("InputFieldBackground"))
                                .cornerRadius(8)
                                .foregroundColor(Color("TextColor"))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Username")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            TextField("", text: $username)
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

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Confirm Password")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            SecureField("", text: $confirmPassword)
                                .padding()
                                .background(Color("InputFieldBackground"))
                                .cornerRadius(8)
                                .foregroundColor(Color("TextColor"))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("First Name")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            TextField("", text: $firstName)
                                .padding()
                                .background(Color("InputFieldBackground"))
                                .cornerRadius(8)
                                .foregroundColor(Color("TextColor"))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Last Name")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            TextField("", text: $lastName)
                                .padding()
                                .background(Color("InputFieldBackground"))
                                .cornerRadius(8)
                                .foregroundColor(Color("TextColor"))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Phone Number")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            TextField("", text: $phoneNumber)
                                .padding()
                                .background(Color("InputFieldBackground"))
                                .cornerRadius(8)
                                .foregroundColor(Color("TextColor"))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Date of Birth")
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                            TextField("", text: Binding(
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
                        }
                    }
                    .padding(.horizontal)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.montserrat(size: 14))
                    }

                    Button(action: registerUser) {
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
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

                    HStack {
                        Text("Already have an account?")
                            .font(.montserrat(size: 14))
                            .foregroundColor(.gray)

                        Button("Login") {
                            onSignUp()
                        }
                        .font(.montserrat(size: 14, weight: .bold))
                        .foregroundColor(Color("PrimaryAccent"))
                    }
                    .padding(.bottom, 30)
                }
                .padding()
                .padding(.bottom, keyboard.currentHeight)
                .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color.white)
            .navigationDestination(isPresented: $navigateToVerify) {
                VerifyEmailView(email: email) {
                    onSignUp()
                }
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
