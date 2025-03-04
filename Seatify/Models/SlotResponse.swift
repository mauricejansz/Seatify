//
//  SlotResponse.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import Foundation

struct SlotResponse: Codable, Identifiable {
    let id: Int
    let table: String  // This stores the table number
    let capacity: Int
    let date: String
    let time: String
    let status: String
}
