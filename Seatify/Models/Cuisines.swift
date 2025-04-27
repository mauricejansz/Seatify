//
//  Cuisines.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-05.
//
import Foundation
import SwiftUI

struct Cuisine: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let image_data: String?
    let keyword: String

    var image: UIImage? {
        guard let imageData = Data(base64Encoded: image_data ?? "", options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
