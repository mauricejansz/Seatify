//
//  PaymentScreen.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-04.
//

import SwiftUI

struct PaymentScreen: View {
    let reservationDetails: ReservationRequest
    @Environment(\.presentationMode) var presentationMode
    @State private var isProcessing = false
    @State private var paymentSuccessful = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Confirm Payment")
                .font(.montserrat(size: 22, weight: .bold))

            Text("Amount: Rs. 1500.00")
                .font(.montserrat(size: 18))
                .foregroundColor(.gray)

            if isProcessing {
                ProgressView("Processing...")
            } else {
                Button(action: {
                    confirmPayment()
                }) {
                    Text("Confirm Payment")
                        .font(.montserrat(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(paymentSuccessful)
        .alert("Payment Successful", isPresented: $paymentSuccessful) {
            Button("OK", role: .cancel) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func confirmPayment() {
        isProcessing = true
        errorMessage = nil

        let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/reservations/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let accessToken = KeychainHelper.retrieveToken(for: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(reservationDetails)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isProcessing = false
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    errorMessage = "No response from server"
                    return
                }
                do {
                    let _ = try JSONDecoder().decode(ReservationResponse.self, from: data)
                    paymentSuccessful = true
                } catch {
                    errorMessage = "Failed to process reservation"
                }
            }
        }.resume()
    }
}
