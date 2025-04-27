//
//  MenuItem.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//
import Foundation

struct MenuCategory: Codable, Hashable {
    let category: String
    let items: [MenuItem]
}

struct MenuItem: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let price: String
}

