//
//  ReviewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: Int
    let user_id: Int
    let user_name: String
    let restaurant_id: Int
    let name: String
    let rating: Double
    let comment: String
}
