//
//  ReviewModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: Int
    let name: String
    let rating: Double
    let comment: String
}
