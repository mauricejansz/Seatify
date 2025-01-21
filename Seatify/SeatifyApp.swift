//
//  SeatifyApp.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//

import SwiftUI

@main
struct SeatifyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
