//
//  GymView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 2/15/21.
//

import SwiftUI

struct GymView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var pass: Pass
    @ObservedObject var mode = ThemeStatus()
    @ObservedObject var user = joinUser()
    @State var gymList = [Substring]()
    @State var currDate = "1"
    
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
    
    func getGym() {
        if user.user.count > 0 {
            guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(user.user[0].id)/\(currDate)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([GymData].self, from: data) {
                    for i in decoded {
                        var result = i.activity
                        result = result.replacingOccurrences(of: "[", with: "")
                        result = result.replacingOccurrences(of: "]", with: "")
                        result = result.replacingOccurrences(of: ",", with: "")
                        result = result.replacingOccurrences(of: "\"", with: "")
                        gymList = result.split(separator: " ")
                    }
                }
            }.resume()
        }
    }
    
    func postGym(_ id: String, _ date: String, _ activites: [String], _ completion: [Bool]) {
        let dateQuery = "\(date)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let activityQuery = "\(activites)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let completionQuery = "\(completion)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(id)/\(dateQuery)/\(activityQuery)/\(completionQuery)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        let body = [
            "id": "478304AB-FBEB-47F8-AB0A-676D1A1932D0",
            "date": date,
            "activity": "\(activites)",
            "completion": "\(completion)"
        ] as [String: Any]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode([GymData].self, from: data) {
                print(decoded)
            }
        }.resume()
    }

    func putGym(_ id: String, _ date: String, _ newActivities: [String], _ newCompletion: [Bool]) {
        let newActivityQuery = "\(newActivities)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let newCompletionQuery = "\(newCompletion)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(id)/\(date)/\(newActivityQuery)/\(newCompletionQuery)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else { return }
        }.resume()
    }
    
    var body: some View {
        ZStack {
            getBackground()
                .ignoresSafeArea(.all)
            VStack(alignment: .center) {
                ScrollView(.vertical) {
                    ForEach(gymList, id: \.self) { element in
                        Text(element)
                            .foregroundColor(getForeground())
                        Rectangle()
                            .fill(getForeground())
                            .frame(height: 1)
                            .edgesIgnoringSafeArea(.horizontal)
                    }
                }
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
            .onAppear(perform: getGym)
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }
}
