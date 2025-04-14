//
//  VerifyEmailView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-12.
//

import SwiftUI

struct VerifyEmailView: View {
    @State private var code = ""
    @State private var errorMessage: String?
    @State private var isVerifying = false
    let email: String
    let onVerified: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image("mail")
                .resizable()
                .frame(width: 60, height: 60)

            Text("Verify Your Email Address")
                .font(.montserrat(size: 18, weight: .bold))

            Text("A code has been emailed to \(email)")
                .multilineTextAlignment(.center)
                .font(.montserrat(size: 14))
                .foregroundColor(.gray)

            TextField("Enter Code", text: $code)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: verifyCode) {
                if isVerifying {
                    ProgressView()
                } else {
                    Text("Verify")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }

    func verifyCode() {
        guard let url = URL(string: "\(AppConfig.backendURL)/accounts/api/verify_email/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": email,
            "code": code
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            self.errorMessage = "Error forming request"
            return
        }

        isVerifying = true

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isVerifying = false
                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "Invalid response"
                    return
                }

                if httpResponse.statusCode == 200 {
                    onVerified() // move to login or auto login
                } else {
                    errorMessage = "Invalid code or verification failed"
                }
            }
        }.resume()
    }
}
