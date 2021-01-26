//
//  MapView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/26/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @ObservedObject var pass: Pass
    @State var centerCoordinate = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    
    init(pass: Pass) {
        self.pass = pass
        setGeocodingData()
    }
    
    func setGeocodingData() {
        guard let url = URL(string: "http://ip-api.com/json") else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(GeocodingData.self, from: data) {
                DispatchQueue.main.async {
                    pass.location = decoded.city
                }
            }
        }.resume()
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                if let _ = self.locationManager.location {
                    let locValue: CLLocationCoordinate2D = self.locationManager.location?.coordinate ?? CLLocationCoordinate2D()
                    print("CURRENT LOCATION = \(locValue.latitude) \(locValue.longitude)")
                    print(centerCoordinate)
                    let coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    view.setRegion(region, animated: true)
                }
            })
        }
    }
}
