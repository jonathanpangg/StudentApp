//
//  WeatherView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/20/21.
//

import SwiftUI

struct WeatherView: View {
    let key                  = "4e28fd44172171a9678306f1648809fa"
    @State var weatherData   = WeatherData()
    @State var statusImage   = ""
    @State var location      = ""
    @ObservedObject var screen: Screen
    @Environment(\.colorScheme) var colorScheme
    // 698c43ba2eefbce9d798d13c1e6acc2f
    // gets default location
    func setGeocodingData() {
        guard let url = URL(string: "http://ip-api.com/json") else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "application/json": "Content-Type",
        ]
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(GeocodingData.self, from: data) {
                location = decoded.city
                getData()
            }
        }.resume()
    }
    
    // gets weather data
    func getData() {
        let query = "\(location)&appid=\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(String(describing: query))") else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "application/json": "Content-Type",
            "Authorization": key
        ]
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(WeatherData.self, from: data) {
                weatherData = decoded
                switch decoded.weather[0].main {
                case "Thunderstorm":
                    statusImage = "cloud.bolt.rain.fill"
                case "Drizzle":
                    statusImage = "cloud.drizzle.fill"
                case "Rain":
                    statusImage = "cloud.heavyrain.fill"
                case "Snow":
                    statusImage = "snow"
                case "Atmosphere":
                    statusImage = "smoke.fill"
                case "Clear":
                    statusImage = "sun.max.fill"
                default:
                    statusImage = "cloud.fill"
                }
            }
        }.resume()
    }
    
    // changes the temperature color
    func changeTempColor() -> Color {
        if (weatherData.main.temp - 273.15) * 1.8 + 32 < 40 {
            return Color.blue
        }
        else if (weatherData.main.temp - 273.15) * 1.8 + 32 < 80 {
            return Color.yellow
        }
        return Color.orange
    }
    
    // changes the temp ring color 
    func changeTempRingColor() -> LinearGradient {
        if (weatherData.main.temp - 273.15) * 1.8 + 32 < 40 {
            return LinearGradient(gradient: Gradient(colors: [Color.lightGreen, Color.lightBlue]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        else if (weatherData.main.temp - 273.15) * 1.8 + 32 < 80 {
            return LinearGradient(gradient: Gradient(colors: [Color.orange, Color.lightGreen]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        return LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    // temperature
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 0.75)
                            .stroke(changeTempRingColor(), style: StrokeStyle(lineWidth: 7.5, lineCap: .round, lineJoin: .round))
                            .rotation3DEffect(Angle(degrees: 135), axis: (0, 0, 1))
                            .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                        Text("\((weatherData.main.temp - 273.15) * 1.8 + 32, specifier: "%.0f")°F")
                            .foregroundColor(changeTempColor())
                            .font(.system(size: UIScreen.main.bounds.width / 16))
                    }
                    .padding()
                    Spacer()
                    
                    // weather condition image
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                        Image(systemName: statusImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                    }
                    .padding()
                    Spacer()
                    
                    // wind speed
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 5)
                            .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                        Text("\(weatherData.wind.speed * 2.237, specifier: "%.0f") mph")
                    }
                    .padding()
                }
            }
            
            
            // Location
            HStack {
                TextField("Location: ", text: $location, onCommit: getData)
                    .multilineTextAlignment(.center)
                    .font(.system(size: UIScreen.main.bounds.width / 64 * 5, weight: .bold))
                    .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
                    .frame(width: UIScreen.main.bounds.width / 4 * 3)
            }
            Spacer()
        }
        .onAppear(perform: setGeocodingData)
        // Locks the screen so it is only in portrait
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

extension Color {
    static var lightBlue: Color {
        return Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
    }
    static var lightGreen: Color {
        return Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
    }
}
