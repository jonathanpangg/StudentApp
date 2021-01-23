//
//  FoodView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/21/21.
//

import SwiftUI

struct FoodView: View {
    @ObservedObject var screen: Screen
    @Environment(\.colorScheme) var colorScheme
    @State var locationData = LocationData()
    @State var foodData     = FoodData()
    @State var location     = ""
    @State var radius       = ""
    let key                 = "698c43ba2eefbce9d798d13c1e6acc2f"
    
    func setGeocodingData() {
        guard let url = URL(string: "http://ip-api.com/json") else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(GeocodingData.self, from: data) {
                location = decoded.city
                radius   = "1609.35"
                getLocation()
            }
        }.resume()
    }
    
    func getLocation() {
        let query                   = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url               = URL(string: "https://developers.zomato.com/api/v2.1/locations?query=\(query)") else { return }
        var request                 = URLRequest(url: url)
        request.httpMethod          = "GET"
        request.allHTTPHeaderFields = [
            "X-Zomato-API-Key": key,
            "Content-Type": "application/json"
        ]
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(LocationData.self, from: data) {
                locationData = decoded
                getFoodData()
            }
        }.resume()
    }
    
    func getFoodData() {
        guard let url               = URL(string: "https://developers.zomato.com/api/v2.1/search?entity_id=\(locationData.locationSuggestions[0].entityID)&entity_type=\(locationData.locationSuggestions[0].entityType)&radius=\(radius)") else { return }
        var request                 = URLRequest(url: url)
        request.httpMethod          = "GET"
        request.allHTTPHeaderFields = [
            "X-Zomato-API-Key": key,
            "Content-Type": "application/json"
        ]
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            // print(try? JSONSerialization.jsonObject(with: data, options: []))
            if let decoded = try? JSONDecoder().decode(FoodData.self, from: data) {
                foodData = decoded
            }
        }.resume()
    }
    
    func getArray(_ array: [RestaurantElement]) -> [String] {
        var list = [String]()
        for i in array {
            list.append("\(i.restaurant.name)")
        }
        return list
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Location: ", text: $location, onCommit: getLocation)
                    .multilineTextAlignment(.center)
                    .font(.system(size: UIScreen.main.bounds.width / 64 * 3, weight: .bold))
                    .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
                    .frame(width: UIScreen.main.bounds.width / 8 * 3)
                    .padding()
                    .offset(x: UIScreen.main.bounds.width / 64 * 3)
                Spacer()
                TextField("Radius: ", text: $radius, onCommit: getLocation)
                    .multilineTextAlignment(.center)
                    .font(.system(size: UIScreen.main.bounds.width / 64 * 3, weight: .bold))
                    .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
                    .frame(width: UIScreen.main.bounds.width / 8 * 3)
                    .padding()
                    .offset(x: UIScreen.main.bounds.width / 64 * -3)
            }
            Text("Restaurants")
                .font(.system(size: UIScreen.main.bounds.width / 64 * 4, weight: .bold))
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(0..<getArray(foodData.restaurants).count, id: \.self) { index in
                        VStack {
                            Tile(getArray(foodData.restaurants)[index], UIScreen.main.bounds.width / 8 * 3, UIScreen.main.bounds.width / 8 * 3, colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                                .onLongPressGesture {
                                    withAnimation {
                                        screen.currentScreen = 2
                                    }
                                }
                                .padding()
                        }
                    }
                }
            }
            HStack {
                Image(systemName: "cloud.sun.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                    .padding()
                    .offset(x: UIScreen.main.bounds.width / 64 * 3)
                    .onTapGesture {
                        withAnimation {
                            screen.currentScreen = 0
                        }
                    }
                Spacer()
                Image(systemName: "bag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                    .padding()
                    .offset(x: UIScreen.main.bounds.width / 64 * -3)
                    .onTapGesture {
                        withAnimation {
                            screen.currentScreen = 1
                        }
                    }
            }
        }
        .onAppear(perform: setGeocodingData)
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

