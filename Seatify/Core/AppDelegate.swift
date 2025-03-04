//
//  AppDelegate.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-01-22.
//

import UIKit
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // ✅ Set the Google Maps API Key Here
        GMSServices.provideAPIKey("AIzaSyDlFwmojUTREwhFfTPBvyXzY30Uilrx0N8")
        
        return true
    }
}
