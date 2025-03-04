//
//  SeatifyApp.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//

import SwiftUI
import GoogleMaps

@main
struct SeatifyApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(name: "Montserrat-Bold", size: 34)!  // Large title
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont(name: "Montserrat-Regular", size: 18)!  // Regular title
        ]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.font, Font.montserrat(size: 16))
        }
    }
}
