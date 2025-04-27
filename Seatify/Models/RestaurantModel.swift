//
//  RestaurantModel.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-24.
//

import Foundation
import SwiftUI

struct Restaurant: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let address: String
    let phone: String
    let cuisine: Cuisine
    let rating: Double
    let lowest_price: Double
    let highest_price: Double
    let is_published: Bool
    let latitude: Double
    let longitude: Double
    let image_data: String?
    let review_count: Int
    let menu_categories: [MenuCategory]

    var image: UIImage? {
        guard let imageData = Data(base64Encoded: image_data ?? "", options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
