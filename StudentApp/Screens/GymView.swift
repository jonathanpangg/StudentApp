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
    @State var completionList = [Substring]()
    @State var currDate = Date()
    @State var increment = 0
    @State var editPressed = false
    @State var addPressed = false
    @State var activity = ""
    
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
        if Int(String(formatter.string(from: date)[formatter.string(from: date).index(after: formatter.string(from: date).firstIndex(of: "/")!)..<(formatter.string(from: date).lastIndex(of: "/") ?? formatter.string(from: date).endIndex)]))! < 10 {
            return "0" + String(formatter.string(from: date)[formatter.string(from: date).index(after: formatter.string(from: date).firstIndex(of: "/")!)..<(formatter.string(from: date).lastIndex(of: "/") ?? formatter.string(from: date).endIndex)])
        }
        else {
            return String(formatter.string(from: date)[formatter.string(from: date).index(after: formatter.string(from: date).firstIndex(of: "/")!)..<(formatter.string(from: date).lastIndex(of: "/") ?? formatter.string(from: date).endIndex)])
        }
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
    
    func getDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func getGym() {
        if user.user.count > 0 {
            guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(user.user[0].id)/\(Int(currDate.timeIntervalSince1970) / 86400)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([GymData].self, from: data) {
                    var count = 0
                    var passed = false
                    while !(count >= 20 || passed) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if decoded.count > 0 {
                                var result = decoded[0].activity
                                var complete = decoded[0].completion
                                result = result.replacingOccurrences(of: "[", with: "")
                                result = result.replacingOccurrences(of: "]", with: "")
                                result = result.replacingOccurrences(of: ",", with: "")
                                result = result.replacingOccurrences(of: "\"", with: "")
                                complete = complete.replacingOccurrences(of: "[", with: "")
                                complete = complete.replacingOccurrences(of: "]", with: "")
                                complete = complete.replacingOccurrences(of: ",", with: "")
                                complete = complete.replacingOccurrences(of: "\"", with: "")
                                gymList = result.split(separator: " ")
                                completionList = complete.split(separator: " ")
                                passed = true
                            }
                            else {
                                gymList = []
                                completionList = []
                            }
                        }
                        count += 1
                    }
                }
            }.resume()
        }
    }
    
    func postGym(_ id: String, _ date: String, _ activites: String, _ completion: String) {
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(id)/\(String(describing: date))/\(activites)/\(completion)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        let body = [
            "id": id,
            "date": date,
            "activity": activites,
            "completion": "\(completion)"
        ] as [String: Any]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else { return }
            DispatchQueue.main.async {
                gymList.append(Substring(activites))
                completionList.append(Substring(completion))
            }
        }.resume()
    }

    func putGym(_ id: String, _ date: String, _ newActivities: [Substring], _ newCompletion: [Substring]) {
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
                HStack(alignment: .center) {
                    Button(action: {
                        editPressed.toggle()
                    }, label: {
                        Text(editPressed ? "Done": "Edit")
                    })
                    .foregroundColor(getForeground())
                    .font(.system(size: UIScreen.main.bounds.width / 20))
                    .offset(x: editPressed ? UIScreen.main.bounds.width / 13: UIScreen.main.bounds.width / 11)
                        
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(getForeground())
                        .font(.system(size: UIScreen.main.bounds.width / 20))
                        .offset(x: UIScreen.main.bounds.width / -10)
                        .onTapGesture {
                            addPressed = true
                        }
                }
                .offset(x: UIScreen.main.bounds.width / -90)
                
                Rectangle()
                    .fill(getForeground())
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                
                HStack(alignment: .center) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .onTapGesture {
                            increment -= 1
                            currDate = Date().addingTimeInterval(TimeInterval(86400 * increment))
                            getGym()
                        }
                    Text("\(getDayOfWeek(currDate)) \(getDay(currDate))")
                        .font(.largeTitle)
                        .frame(width: UIScreen.main.bounds.width / 16 * 7)
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .onTapGesture {
                            increment += 1
                            currDate = Date().addingTimeInterval(TimeInterval(86400 * increment))
                            getGym()
                        }
                }
                .foregroundColor(getForeground())
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<gymList.count, id: \.self) { index in
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(getForeground())
                                    .frame(width: UIScreen.main.bounds.width / 12, height: UIScreen.main.bounds.width / 12)
                                if index <= completionList.count - 1 {
                                    if completionList[index] == "true" {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color.green)
                                            .frame(width: UIScreen.main.bounds.width / 12 - UIScreen.main.bounds.width / 48, height: UIScreen.main.bounds.width / 12 - UIScreen.main.bounds.width / 48)
                                    }
                                }
                            }
                            .onTapGesture {
                                if completionList[index] == "true" {
                                    completionList[index] = "false"
                                }
                                else {
                                    completionList[index] = "true"
                                }
                                putGym("\(user.user[0].id)", "\(Int(currDate.timeIntervalSince1970) / 86400)", gymList, completionList)
                            }
                            .padding(.leading)
                            Spacer()
                            Text(gymList[index])
                                .foregroundColor(getForeground())
                                .font(.system(size: UIScreen.main.bounds.width / 18))
                                .padding(.trailing)
                        }
                        .frame(width: UIScreen.main.bounds.width / 8 * 7)
                        
                        Rectangle()
                            .fill(getForeground())
                            .frame(width: UIScreen.main.bounds.width / 8 * 7, height: 1)
                            .edgesIgnoringSafeArea(.horizontal)
                    }
                }
                .padding(.top)
                
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
            .opacity(addPressed ? 0.5: 1)
            .blur(radius: addPressed ? 1: 0)
            .onAppear(perform: getGym)
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
            
            if addPressed {
                ZStack {
                    Text("")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(getForeground())
                        .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                        .background(getBackground())
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                    HStack {
                        VStack(alignment: .center, spacing: 0) {
                            TextField("Gym Activity:", text: $activity)
                                .multilineTextAlignment(.center)
                                .foregroundColor(getForeground())
                            Spacer()
                            
                            Rectangle()
                                .fill(getForeground())
                                .frame(height: 1)
                                .edgesIgnoringSafeArea(.horizontal)
                            
                            HStack(alignment: .center) {
                                HStack(alignment: .center) {
                                    Text("Enter")
                                        .foregroundColor(getForeground())
                                }
                                .frame(width: (UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 16) / 2)
                                .offset(x: UIScreen.main.bounds.width / 64)
                                .onTapGesture {
                                    if gymList.count == 0 {
                                        if user.user.count > 0 {
                                            postGym("\(user.user[0].id)", "\(Int(currDate.timeIntervalSince1970) / 86400)", "\(activity)", "false")
                                            addPressed = false
                                            activity = ""
                                            getGym()
                                        }
                                    }
                                    else {
                                        if user.user.count > 0 {
                                            gymList.append(Substring(activity))
                                            completionList.append(Substring("false"))
                                            putGym("\(user.user[0].id)", "\(Int(currDate.timeIntervalSince1970) / 86400)", gymList, completionList)
                                            addPressed = false
                                            activity = ""
                                            getGym()
                                        }
                                    }
                                }
                                
                                Rectangle()
                                    .fill(getForeground())
                                    .frame(width: 1, height: UIScreen.main.bounds.height / 24)
                                    .edgesIgnoringSafeArea(.vertical)
                                
                                HStack(alignment: .center) {
                                    Text("Cancel")
                                        .foregroundColor(getForeground())
                                }
                                .frame(width: (UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 16) / 2)
                                .offset(x: UIScreen.main.bounds.width / -64)
                                .onTapGesture {
                                    withAnimation {
                                        addPressed = false
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 16)
                    .background(getBackground())
                }
                .background(getBackground())
            }
        }
    }
}
