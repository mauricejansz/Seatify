//
//  RestaurantMapView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-02-27.
//

import SwiftUI
import GoogleMaps

struct RestaurantMapView: UIViewRepresentable {
    let latitude: Double
    let longitude: Double
    let title: String
    
    func makeUIView(context: Context) -> GMSMapView {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        let mapView = GMSMapView(options:options)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.map = mapView
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {}
}
