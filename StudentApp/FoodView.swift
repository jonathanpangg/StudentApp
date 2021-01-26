//
//  FoodView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/21/21.
//

import SwiftUI
import MapKit

struct FoodView: View {
    @ObservedObject var pass: Pass
    @Environment(\.colorScheme) var colorScheme
    @State var locationData = LocationData()
    @State var radius = "3218.69"
    @State var lat = ""
    @State var long = ""
    let key = "698c43ba2eefbce9d798d13c1e6acc2f"
        
    // gets the location data
    func getLocation() {
        let query = pass.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://developers.zomato.com/api/v2.1/locations?query=\(query)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
    
    // gets food data
    func getFoodData() {
        guard let url = URL(string: "https://developers.zomato.com/api/v2.1/search?entity_id=\(locationData.locationSuggestions[0].entityID)&entity_type=\(locationData.locationSuggestions[0].entityType)&radius=\(radius)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-Zomato-API-Key": key,
            "Content-Type": "application/json"
        ]
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(FoodData.self, from: data) {
                DispatchQueue.main.async {
                    pass.foodData = decoded
                }
            }
            else {
                DispatchQueue.main.async {
                    pass.foodData = FoodData()
                }
            }
        }.resume()
    }
    
    // returns an array representation
    func getArrayName(_ array: [RestaurantElement]) -> [String] {
        var list = [String]()
        for i in array {
            list.append("\(String(describing: i.restaurant!.name ?? ""))")
        }
        return list
    }
    
    func getArrayAddress(_ array: [RestaurantElement]) -> [String] {
        var list = [String]()
        for i in array {
            list.append("\(String(describing: i.restaurant!.location?.address ?? ""))")
        }
        return list
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("Location: ", text: $pass.location, onCommit: getLocation)
                        .multilineTextAlignment(.center)
                        .font(.system(size: UIScreen.main.bounds.width / 64 * 3, weight: .bold))
                        .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
                        .frame(width: UIScreen.main.bounds.width / 16 * 7)
                        .offset(x: UIScreen.main.bounds.width / 64 * 2)
                    Spacer()
                    TextField("Radius: ", text: $radius, onCommit: getLocation)
                        .multilineTextAlignment(.center)
                        .font(.system(size: UIScreen.main.bounds.width / 64 * 3, weight: .bold))
                        .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
                        .frame(width: UIScreen.main.bounds.width / 16 * 7)
                        .offset(x: UIScreen.main.bounds.width / 64 * -2)
                }
                Tile("Restaurants", UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 32, colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black, UIScreen.main.bounds.width / 16, .bold)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
                    .frame(width: UIScreen.main.bounds.width)
                Spacer()
                
                MapView(pass: pass)
                    .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                    .frame(width: UIScreen.main.bounds.width / 16 * 15, height: UIScreen.main.bounds.height / 16 * 9)
                    
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        ForEach(0..<getArrayName(pass.foodData.restaurants ?? []).count, id: \.self) { index in
                            VStack {
                                Tile("\(getArrayName(pass.foodData.restaurants ?? [])[index])\n\n\(getArrayAddress(pass.foodData.restaurants ?? [])[index])", UIScreen.main.bounds.width / 16 * 5, UIScreen.main.bounds.width / 16 * 5, colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                                    .padding()
                            }
                        }
                    }
                }
                Spacer()
                
                HStack(alignment: .center) {
                    Image(systemName: "cloud.sun.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                        .offset(x: UIScreen.main.bounds.width / 64 * 3)
                        .onTapGesture {
                            pass.currentScreen = 0
                        }
                        .padding()
                    Spacer()
                    Image(systemName: "bag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                        .offset(x: UIScreen.main.bounds.width / 64 * -3)
                        .padding()
                }
                .frame(height: UIScreen.main.bounds.height / 64 * 2)
                .offset(y: UIScreen.main.bounds.height / 256 * -1)
            }
        }
        .onAppear(perform: getLocation)
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
