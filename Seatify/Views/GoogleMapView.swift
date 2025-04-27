//
//  GoogleMapView.swift
//  Seatify
//
//  Created by Maurice Jansz on 2025-04-24.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    let restaurants: [Restaurant]
    let onTapMarker: (Restaurant) -> Void

    @ObservedObject private var locationManager = LocationManager()

    func makeCoordinator() -> Coordinator {
        Coordinator(onTapMarker: onTapMarker)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let defaultLat = restaurants.first?.latitude ?? 6.9271
        let defaultLng = restaurants.first?.longitude ?? 79.8612

        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(
            withLatitude: locationManager.userLocation?.latitude ?? defaultLat,
            longitude: locationManager.userLocation?.longitude ?? defaultLng,
            zoom: 13
        )

        let mapView = GMSMapView(options: options)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        context.coordinator.mapView = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.clear()

        for restaurant in restaurants {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            marker.userData = restaurant
            marker.icon = generateMarkerIcon(rating: restaurant.rating)
            marker.map = uiView
        }

        if !context.coordinator.hasCenteredCamera, let location = locationManager.userLocation {
            let camera = GMSCameraPosition.camera(
                withLatitude: location.latitude,
                longitude: location.longitude,
                zoom: 13
            )
            uiView.animate(to: camera)
            context.coordinator.hasCenteredCamera = true
        }
    }

    private func generateMarkerIcon(rating: Double) -> UIImage {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.layer.cornerRadius = 18
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.lightGray.cgColor

        let imageView = UIImageView(image: UIImage(systemName: "fork.knife.circle.fill"))
        imageView.tintColor = UIColor.systemRed
        imageView.frame = CGRect(x: 8, y: 8, width: 20, height: 20)
        container.addSubview(imageView)

        let label = UILabel()
        label.text = String(format: "%.1f", rating)
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.frame = CGRect(x: 38, y: 8, width: 40, height: 24)
        container.addSubview(label)

        container.frame = CGRect(x: 0, y: 0, width: 80, height: 40)

        UIGraphicsBeginImageContextWithOptions(container.bounds.size, false, 0)
        container.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        let onTapMarker: (Restaurant) -> Void
        var hasCenteredCamera = false
        weak var mapView: GMSMapView?

        init(onTapMarker: @escaping (Restaurant) -> Void) {
            self.onTapMarker = onTapMarker
        }

        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let restaurant = marker.userData as? Restaurant {
                onTapMarker(restaurant)
            }
            return true
        }
    }
}
