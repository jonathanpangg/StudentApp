//
//  PassVariables.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/23/21.
//

import SwiftUI

class Pass: ObservableObject {
    @Published var currentScreen: Int = 4
    @Published var location: String = ""
    @Published var lat: Double = 0
    @Published var lng: Double = 0
    @Published var foodData: FoodData = FoodData()
    @Published var index: Int = 0
    
    // sets default location
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
                    self.location = decoded.city
                    self.lat = decoded.lat
                    self.lng = decoded.lon
                }
            }
        }.resume()
    }
    
    init() { setGeocodingData() }
}
