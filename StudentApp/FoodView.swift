//
//  FoodView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/21/21.
//

import SwiftUI

struct FoodView: View {
    @ObservedObject var screen: Screen
    @State var locationData = LocationData()
    @State var location     = ""
    let key = "698c43ba2eefbce9d798d13c1e6acc2f"
    
    func getLocation() {
        let query     = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://developers.zomato.com/api/v2.1/locations?query=\(query)") else { return }
        var request   = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-Zomato-API-Key": key,
            "Content-Type": "application/json"
        ]
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            print(try? JSONSerialization.jsonObject(with: data, options: []))
            if let decoded = try? JSONDecoder().decode(LocationData.self, from: data) {
                locationData = decoded
                print(locationData.locationSuggestions[0].cityName)
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Location: ", text: $location, onCommit: getLocation)
                    .autocapitalization(.none)
                
            }
        }
    }
}

