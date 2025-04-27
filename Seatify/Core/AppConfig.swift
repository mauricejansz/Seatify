//
//  AppConfig.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-03-03.
//

import Foundation

struct AppConfig {
    // Define backend URLs
    private static let productionURL = "https://ultimate-wired-troll.ngrok-free.app"
    private static let localURL = "http://127.0.0.1:8000"
    static var backendURL: String { productionURL }
}
