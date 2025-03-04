//
//  ReservationRequest.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-04.
//

import Foundation

struct ReservationRequest: Codable {
    let restaurant_id: Int
    let slot_id: Int
    let number_of_guests: Int
    let comments: String
}
