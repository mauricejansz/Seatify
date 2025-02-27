//
//  SlotResponse.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import Foundation

struct SlotResponse: Decodable {
    let id: Int
    let table: String
    let capacity: Int
    let date: String
    let time: String
    let status: String
}
