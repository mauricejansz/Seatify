//
//  ReviewRequest.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-05.
//

import Foundation

struct ReviewRequest: Codable {
    let rating: Double
    let comment: String
}
