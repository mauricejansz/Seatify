//
//  ReservationResponse.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-04.
//

import Foundation

struct ReservationResponse: Codable {
    let id: Int
    let status: String
    let payment_status: String
}
