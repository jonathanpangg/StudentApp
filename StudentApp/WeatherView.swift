//
//  WeatherView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/20/21.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var pass: Pass
    @Environment(\.colorScheme) var colorScheme
    @State var weatherData = WeatherData()
    @State var statusImage = ""
    @State var isCity = true
    @State var location = ""
    let key = "4e28fd44172171a9678306f1648809fa"
    
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
                    location = decoded.city
                    getData()
                }
            }
        }.resume()
    }
    
    // gets weather data
    func getData() {
        var query = ""
        if pass.location == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                if isCity {
                    query = "\(pass.location)&appid=\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
                else {
                    query = "\(location)&appid=\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
                guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(String(describing: query))") else { return }
                var request = URLRequest(url: url)
                request.allHTTPHeaderFields = [
                    "application/json": "Content-Type",
                    "Authorization": key
                ]
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else { return }
                    if let decoded = try? JSONDecoder().decode(WeatherData.self, from: data) {
                        DispatchQueue.main.async {
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
                    }
                }.resume()
            }
        }
        else {
            if isCity {
                query = "\(pass.location)&appid=\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            else {
                query = "\(location)&appid=\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(String(describing: query))") else { return }
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "application/json": "Content-Type",
                "Authorization": key
            ]
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        isCity = true
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
                }
                else {
                    isCity = false
                    setGeocodingData()
                }
            }.resume()
        }
    }
    
    // changes the temperature color
    func changeTempColor() -> Color {
        if (weatherData.main.temp - 273.15) * 1.8 + 32 < 40 {
            return Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
        }
        else if (weatherData.main.temp - 273.15) * 1.8 + 32 < 80 {
            return Color.yellow
        }
        return Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
    }
    
    // returns the day of the week
    func getDayOfWeek(_ date: Date) -> String {
        let toStringFormatter = DateFormatter()
        toStringFormatter.dateStyle = .short
        let toDayOfWeekFormatter = DateFormatter()
        toDayOfWeekFormatter.dateFormat = "MM/dd/yy"
        guard let todayDate = toDayOfWeekFormatter.date(from: toStringFormatter.string(from: date)) else { return "" }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        switch weekDay {
        case 0:
            return "Sat"
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tues"
        case 4:
            return "Wed"
        case 5:
            return "Thurs"
        default:
            return "Fri"
        }
    }
    
    // returns the month
    func getMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        switch formatter.string(from: date)[formatter.string(from: date).startIndex..<(formatter.string(from: date).firstIndex(of: " ") ?? formatter.string(from: date).endIndex)] {
        case "January":
            return "Jan"
        case "February":
            return "Feb"
        case "March":
            return "March"
        case "April":
            return "April"
        case "May":
            return "May"
        case "June":
            return "June"
        case "July":
            return "July"
        case "August":
            return "Aug"
        case "September":
            return "Sept"
        case "October":
            return "Oct"
        case "November":
            return "Nov"
        default:
            return "Dec"
        }
    }
    
    // returns the day
    func getDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return String(formatter.string(from: date)[formatter.string(from: date).index(after: formatter.string(from: date).firstIndex(of: "/")!)..<(formatter.string(from: date).lastIndex(of: "/") ?? formatter.string(from: date).endIndex)])
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("\(getDayOfWeek(Date())) \(getMonth(Date())) \(getDay(Date()))")
                        .font(.headline)
                        .padding(.leading)
                    Spacer()
                }
                ZStack {
                    HStack {
                        // temperature
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 0)
                                .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                                .clipShape(Circle())
                                .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
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
                                .stroke(lineWidth: 0)
                                .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                                .clipShape(Circle())
                                .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
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
                                .stroke(lineWidth: 0)
                                .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                                .clipShape(Circle())
                                .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) ,radius: 10, x: 6, y: 4)
                                .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                            Text("\(weatherData.wind.speed * 2.237, specifier: "%.0f") mph")
                        }
                        .padding()
                    }
                }
                Spacer()
                
                HStack(alignment: .center) {
                    Image(systemName: "cloud.sun.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                        .offset(x: UIScreen.main.bounds.width / 64 * 3)
                        .padding()
                    Spacer()
                    Image(systemName: "bag.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                        .onTapGesture {
                            withAnimation {
                                pass.currentScreen = 1
                            }
                        }
                        .offset(x: UIScreen.main.bounds.width / 64 * -3)
                        .padding()
                }
                .frame(height: UIScreen.main.bounds.height / 64 * 2)
                .offset(y: UIScreen.main.bounds.height / 256 * -1)
            }
            .onAppear(perform: getData)
            // Locks the screen so it is only in portrait
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
            .navigationTitle(pass.location)
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
