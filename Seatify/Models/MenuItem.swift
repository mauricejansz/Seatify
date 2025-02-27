//
//  MenuItem.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//
import Foundation

struct MenuCategory: Codable {
    let category: String
    let items: [MenuItem]
}

struct MenuItem: Codable {
    let id: Int
    let name: String
    let description: String
    let price: String
}

