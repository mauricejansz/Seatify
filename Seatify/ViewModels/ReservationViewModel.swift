//
//  ReservationViewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-17.
//

import Foundation

class ReservationsViewModel: ObservableObject {
    @Published var activeReservations: [Reservation] = []
    @Published var pastReservations: [Reservation] = []

    func fetchReservations() {
        guard let token = KeychainHelper.retrieveToken(for: "accessToken") else { return }
        guard let url = URL(string: "\(AppConfig.backendURL)/api/restaurants/user_reservations/") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching reservations:", error?.localizedDescription ?? "Unknown")
                return
            }

            do {
                let reservations = try JSONDecoder().decode([Reservation].self, from: data)
                let today = Date()

                let active = reservations.filter { $0.reservationDate ?? today >= today }
                let past = reservations.filter { $0.reservationDate ?? today < today }

                DispatchQueue.main.async {
                    self.activeReservations = active
                    self.pastReservations = past
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
