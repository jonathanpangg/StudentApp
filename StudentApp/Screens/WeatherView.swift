//
//  WeatherView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/20/21.
//

import SwiftUI
import UserNotifications

struct WeatherView: View {
    @ObservedObject var pass: Pass
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var mode = ThemeStatus()
    @ObservedObject var status = NotificationStatus()
    @State var weatherData = WeatherData()
    @State var statusImage = ""
    @State var isCity = true
    @State var location = ""
    let weatherKey = "4e28fd44172171a9678306f1648809fa"
    let geoKey = "698c43ba2eefbce9d798d13c1e6acc2f"
    
    func getForeground() -> Color {
        if mode.mode.mode == "Default" {
            return colorScheme != .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)): Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
        else if mode.mode.mode == "Light"{
            return Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
        else {
            return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
    }
    
    func getBackground() -> Color {
        if mode.mode.mode == "Default" {
            return colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black
        }
        else if mode.mode.mode == "Light"{
            return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
        else {
            return Color.black
        }
    }
    
    // returns the day
    func getDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return String(formatter.string(from: date)[formatter.string(from: date).index(after: formatter.string(from: date).firstIndex(of: "/")!)..<(formatter.string(from: date).lastIndex(of: "/") ?? formatter.string(from: date).endIndex)])
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
        case 6:
            return "Fri"
        default:
            return "Sat"
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
    
    // gets the location data
    func getLocation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            guard let url = URL(string: "https://developers.zomato.com/api/v2.1/geocode?lat=\(pass.lat)&lon=\(pass.lng)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "X-Zomato-API-Key": geoKey,
                "Content-Type": "application/json"
            ]
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode(ReverseGeo.self, from: data) {
                    DispatchQueue.main.async {
                        location = decoded.location.city_name
                        pass.lat = Double(decoded.location.latitude)!
                        pass.lng = Double(decoded.location.longitude)!
                        getData()
                    }
                }
            }.resume()
        }
    }
    
    // gets weather data
    func getData() {
        var query = ""
        if pass.location == "" {
            if isCity {
                query = "\(pass.location)&appid=\(weatherKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            else {
                query = "\(location)&appid=\(weatherKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(String(describing: query))") else { return }
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "application/json": "Content-Type",
                "Authorization": weatherKey
            ]
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        weatherData = decoded
                        setNotification()
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
        else {
            location = pass.location
            if isCity {
                query = "\(pass.location)&appid=\(weatherKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            else {
                query = "\(location)&appid=\(weatherKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(String(describing: query))") else { return }
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "application/json": "Content-Type",
                "Authorization": weatherKey
            ]
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        isCity = true
                        weatherData = decoded
                        setNotification()
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
                            if let time = getTimeComponents() {
                                if time >= 6 && time < 18 {
                                    statusImage = "sun.max.fill"
                                }
                                else {
                                    statusImage = "moon.fill"
                                }
                            }
                            else {
                                statusImage = "sun.max.fill"
                            }
                        default:
                            statusImage = "cloud.fill"
                        }
                    }
                }
                else {
                    isCity = false
                    getLocation()
                }
            }.resume()
        }
    }
    
    func getTimeComponents() -> Int? {
        return Calendar.current.dateComponents([.hour, .minute], from: Date()).hour
    }

    // returns the time interval for a notification
    func getTimeInterval(_ hourComponent: Int, _ minuteComponent: Int) -> Int {
        var endHour = hourComponent
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())

        while endHour < components.hour! {
            endHour += 24
        }
        
        if minuteComponent < 10 {
            return (Int("\(endHour)0\(minuteComponent)")! - Int("\(components.hour!)\(components.minute!)")!) * 60
        }
        return (Int("\(endHour)\(minuteComponent)")! - Int("\(components.hour!)\(components.minute!)")!) * 60
    }
    
    // sets a notification for the weather
    func setNotification() {
        if status.status.status == "ON" {
            let content = UNMutableNotificationContent()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            content.title = "Weather Update"
            if weatherData.weather.count > 0 {
                content.subtitle = "Today there is \(weatherData.weather[0].weatherDescription) in \(pass.location)"
            }
            content.sound = UNNotificationSound.default
            if getTimeInterval(6, 0) > 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(getTimeInterval(6, 0)), repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        UNUserNotificationCenter.current().add(request)
                    }
                    else {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                UNUserNotificationCenter.current().add(request)
                            }
                        }
                    }
                    UNUserNotificationCenter.current().add(request)
                }
            }
        }
        else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    var body: some View {
        ZStack {
            MapView(pass: pass)
                .hidden()
            getBackground()
                .ignoresSafeArea(.all)
            VStack {
                VStack {
                    HStack {
                        Text(location)
                            .font(.system(size: UIScreen.main.bounds.width / 8))
                            .background(getBackground())
                            .foregroundColor(getForeground())
                            .padding(.leading)
                        Spacer()
                    }
                    if statusImage != "" {
                        HStack {
                            Text("\(getDayOfWeek(Date())) \(getMonth(Date())) \(getDay(Date()))")
                                .font(.headline)
                                .background(getBackground())
                                .foregroundColor(getForeground())
                                .padding(.leading)
                            Spacer()
                        }
                        .background(getBackground())
                    
                        HStack {
                            // temperature
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 0)
                                    .background(getBackground())
                                    .clipShape(Circle())
                                    .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
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
                                    .background(getBackground())
                                    .clipShape(Circle())
                                    .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                                    .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                                Image(systemName: statusImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                                    .foregroundColor(Color.lightBlue)
                            }
                            .padding()
                            Spacer()
                            
                            // wind speed
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 0)
                                    .background(getBackground())
                                    .clipShape(Circle())
                                    .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                                    .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                                Text("\(weatherData.wind.speed * 2.237, specifier: "%.0f") mph")
                                    .foregroundColor(getForeground())
                            }
                            .padding()
                        }
                    }
                    else {
                        EmptyView()
                            .onAppear(perform: getLocation)
                    }
                }
                .animation(.linear)
                Spacer()
                
                HStack(alignment: .center) {
                    VStack {
                        Image(systemName: "cloud.sun.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 12, height: UIScreen.main.bounds.width / 12)
                            .foregroundColor(getForeground())
                        Text("Weather")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 12))
                            .foregroundColor(getForeground())
                    }
                    .onTapGesture {
                        pass.currentScreen = 0
                    }
                    .offset(x: UIScreen.main.bounds.width / 64 * 3)
                    .padding()
                    Spacer()
                    
                    VStack {
                        Image(systemName: "bag.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 12, height: UIScreen.main.bounds.width / 12)
                            .foregroundColor(getForeground())
                        Text("Restaurants")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 12))
                            .foregroundColor(getForeground())
                    }
                    .onTapGesture {
                        pass.currentScreen = 1
                    }
                    .offset(x: UIScreen.main.bounds.width / 64 * 1)
                    .padding()
                    Spacer()
                    
                    VStack {
                        Image(systemName: "figure.walk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 12, height: UIScreen.main.bounds.width / 12)
                            .foregroundColor(getForeground())
                        Text("Gym")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 12))
                            .foregroundColor(getForeground())
                    }
                    .onTapGesture {
                        pass.currentScreen = 6
                    }
                    .offset(x: UIScreen.main.bounds.width / 64 * -1)
                    .padding()
                    Spacer()
                    
                    VStack {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 12, height: UIScreen.main.bounds.width / 12)
                            .foregroundColor(getForeground())
                        Text("Settings")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 12))
                            .foregroundColor(getForeground())
                    }
                    .onTapGesture {
                        pass.currentScreen = 2
                    }
                    .offset(x: UIScreen.main.bounds.width / 64 * -3)
                    .padding()
                }
                .background(getBackground())
                .frame(height: UIScreen.main.bounds.height / 64 * 1)
                .offset(y: UIScreen.main.bounds.height / 256 * -1)
            }
            .background(getBackground())
            .onAppear(perform: getData)
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
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
