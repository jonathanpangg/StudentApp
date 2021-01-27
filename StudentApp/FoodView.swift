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
    @State var locationData = RevserGeo()
    @State var radius = "3218.69"
    @State var lat = ""
    @State var long = ""
    @State var listPressed = false
    let key = "698c43ba2eefbce9d798d13c1e6acc2f"
        
    // gets the location data
    func getLocation() {
        guard let url = URL(string: "https://developers.zomato.com/api/v2.1/geocode?lat=\(pass.lat)&lon=\(pass.lng)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-Zomato-API-Key": key,
            "Content-Type": "application/json"
        ]
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(RevserGeo.self, from: data) {
                locationData = decoded
                getFoodData()
            }
        }.resume()
    }
    
    // gets food data
    func getFoodData() {
        guard let url = URL(string: "https://developers.zomato.com/api/v2.1/search?entity_id=\(locationData.location.entity_id)&entity_type=\(locationData.location.entity_type)&radius=\(radius)") else { return }
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
    
    func getArrayPhoneNumber(_ array: [RestaurantElement]) -> [String] {
        var list = [String]()
        for i in array {
            list.append("\(String(describing: i.restaurant!.phone_numbers![i.restaurant!.phone_numbers!.startIndex..<(i.restaurant!.phone_numbers?.firstIndex(of: ",") ?? i.restaurant!.phone_numbers!.endIndex)]))")
        }
        return list
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 24, height: UIScreen.main.bounds.width / 24)
                        .scaledToFit()
                        .onTapGesture {
                            withAnimation {
                                listPressed.toggle()
                            }
                        }
                    Spacer()
                }
                .padding()
                
                ZStack {
                    VStack {
                        MapView(pass: pass)
                            .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                            .frame(width: UIScreen.main.bounds.width / 16 * 15)
                            .opacity(listPressed ? 0.5 : 1)
                            .blur(radius: listPressed ? 2 : 0)
                        
                        ZStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.flexible())]) {
                                    ForEach(0..<getArrayName(pass.foodData.restaurants ?? []).count, id: \.self) { index in
                                        VStack {
                                            FoodTile("\(getArrayName(pass.foodData.restaurants ?? [])[index])", StarRating(Int(String(format: "%.0f",  Double((pass.foodData.restaurants?[index].restaurant?.user_rating?.aggregate_rating!)!)!))!), "\(getArrayPhoneNumber(pass.foodData.restaurants ?? [])[index])", UIScreen.main.bounds.width / 8 * 3, UIScreen.main.bounds.width / 8 * 3, colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                                                .padding()
                                        }
                                    }
                                }
                                .offset(x: UIScreen.main.bounds.width / 32)
                            }
                        }
                        .opacity(listPressed ? 0.5 : 1)
                        .blur(radius: listPressed ? 2 : 0)
                        Spacer()
                        
                        HStack(alignment: .center) {
                            VStack {
                                Image(systemName: "cloud.sun.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                                Text("Weather")
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 12))
                            }
                            .onTapGesture {
                                withAnimation {
                                    pass.currentScreen = 0
                                }
                            }
                            .offset(x: UIScreen.main.bounds.width / 64 * 3)
                            .padding()
                            Spacer()
                            
                            VStack {
                                Image(systemName: "bag.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                                Text("Restaurants")
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 12))
                            }
                            .onTapGesture {
                                withAnimation {
                                    pass.currentScreen = 1
                                }
                            }
                            .padding()
                            Spacer()
                            
                            VStack {
                                Image(systemName: "gear")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                                Text("Settings")
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 12))
                            }
                            .onTapGesture {
                                withAnimation {
                                    pass.currentScreen = 2
                                }
                            }
                            .offset(x: UIScreen.main.bounds.width / 64 * -3)
                            .padding()
                        }
                        .frame(height: UIScreen.main.bounds.height / 64 * 2)
                        .offset(y: UIScreen.main.bounds.height / 256 * -1)
                    }
                }
            }
            if listPressed {
                VStack {
                    HStack {}
                        .frame(width: UIScreen.main.bounds.width / 24, height: UIScreen.main.bounds.width / 24)
                        .padding()
                    HStack {
                        FunctionList("Radius:", textfieldString: $radius, UIScreen.main.bounds.width / 1.5, UIScreen.main.bounds.height / 16, colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black, 16)
                        Spacer()
                    }
                    Spacer()
                }
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
