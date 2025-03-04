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
    static var backendURL: String { localURL }
    
    // Computed property to return the correct backend URL
//    static var backendURL: String {
//        return isServerAvailable(urlString: productionURL) ? productionURL : localURL
//    }
//
//    // Function to check if server is available
//    private static func isServerAvailable(urlString: String) -> Bool {
//        guard let url = URL(string: urlString) else { return false }
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"  // Less resource-intensive than GET
//        
//        let semaphore = DispatchSemaphore(value: 0)
//        var isAvailable = false
//
//        let task = URLSession.shared.dataTask(with: request) { _, response, error in
//            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
//                isAvailable = true
//            } else {
//                isAvailable = false
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        
//        _ = semaphore.wait(timeout: .now() + 2) // Wait max 2 seconds for response
//        return isAvailable
//    }
}
