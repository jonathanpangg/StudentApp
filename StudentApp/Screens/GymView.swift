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
    @State var returnData = [GymData]()
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
    
    func getTimeComponents(_ date: Date) -> String {
        guard let month = Calendar.current.dateComponents([.month, .day, .year], from: date).month else { return "" }
        guard let day = Calendar.current.dateComponents([.month, .day, .year], from: date).day else { return "" }
        guard let year = Calendar.current.dateComponents([.month, .day, .year], from: date).year else { return "" }
        if month < 10 && day < 10 {
            return "0\(month)0\(day)\(year)"
        }
        else if month < 10 && day > 10 {
            return "0\(month)\(day)\(year)"
        }
        return "\(month)\(day)\(year)"
    }
    
    func defaultGetGym() {
        if user.user.count > 0 {
            guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(user.user[0].id)/\(getTimeComponents(currDate))") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([GymData].self, from: data) {
                    DispatchQueue.main.async {
                        returnData = decoded
                    }
                }
            }.resume()
        }
    }
    
    func dataGetGym() {
        if user.user.count > 0 {
            guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(user.user[0].id)/\(getTimeComponents(currDate))") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([GymData].self, from: data) {
                    let pastValue = returnData
                    for _ in 0..<10 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            returnData = decoded
                            if returnData != pastValue {
                                return
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    func postGym(_ id: String, _ date: String, _ activites: [String], _ completion: [Bool]) {
        let activityQuery = "\(activites)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let completionQuery = "\(completion)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(id)/\(date)/\(activityQuery)/\(completionQuery)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        let body = [
            "id": id,
            "date": date,
            "activity": activites,
            "completion": completion
        ] as [String: Any]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else { return }
            DispatchQueue.main.async {
                dataGetGym()
            }
        }.resume()
    }
    
    
    func putGym(_ id: String, _ date: String, _ newActivities: [String], _ newCompletion: [Bool]) {
        deleteGym(id, date)
        if newActivities.count > 0 || newCompletion.count > 0 {
            postGym(id, date, newActivities, newCompletion)
        }
    }
    
    func deleteGym(_ id: String, _ date: String) {
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(id)/\(date)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
                        withAnimation {
                            editPressed.toggle()
                        }
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
                            withAnimation {
                                addPressed = true
                            }
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
                            dataGetGym()
                        }
                    Text("\(getDayOfWeek(currDate)) \(getDay(currDate))")
                        .font(.largeTitle)
                        .frame(width: UIScreen.main.bounds.width / 16 * 7)
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .onTapGesture {
                            increment += 1
                            currDate = Date().addingTimeInterval(TimeInterval(86400 * increment))
                            dataGetGym()
                        }
                }
                .foregroundColor(getForeground())
                
                ScrollView(.vertical, showsIndicators: false) {
                    if returnData.count > 0 {
                        ForEach(0..<returnData[0].activity.count, id: \.self) { index in
                            HStack {
                                if editPressed {
                                    ZStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: UIScreen.main.bounds.width / 18, height: UIScreen.main.bounds.width / 18)
                                            .padding(.leading)
                                        Image(systemName: "minus")
                                            .foregroundColor(getForeground())
                                            .frame(width: UIScreen.main.bounds.width / 18 - UIScreen.main.bounds.width / 18 / 2, height: UIScreen.main.bounds.width / 18 - UIScreen.main.bounds.width / 18 / 2)
                                            .padding(.leading)
                                            .onTapGesture {
                                                returnData[0].activity.remove(at: index)
                                                returnData[0].completion.remove(at: index)
                                                putGym("\(user.user[0].id)", getTimeComponents(currDate), returnData[0].activity, returnData[0].completion)
                                            }
                                    }
                                }

                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(getForeground())
                                        .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                                    if index <= returnData[0].completion.count - 1 {
                                        if returnData[0].completion[index] {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.green)
                                                .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 64, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 64)
                                        }
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        returnData[0].completion[index].toggle()
                                        putGym("\(user.user[0].id)", getTimeComponents(currDate), returnData[0].activity, returnData[0].completion)
                                    }
                                }
                                .padding(.leading)
                                Spacer()
                                Text(returnData[0].activity[index])
                                    .foregroundColor(getForeground())
                                    .font(.headline)
                                    .padding(.trailing)
                            }
                            .frame(width: UIScreen.main.bounds.width / 8 * 7)
                            .offset(y: UIScreen.main.bounds.height / 256)
                            
                            Rectangle()
                                .fill(getForeground())
                                .frame(width: UIScreen.main.bounds.width / 8 * 7, height: 1)
                                .edgesIgnoringSafeArea(.horizontal)
                        }
                    }
                }
                .padding(.top)
                
                Rectangle()
                    .fill(getForeground())
                    .frame(width: UIScreen.main.bounds.width, height: 1)
                    .offset(y: UIScreen.main.bounds.height / -28)
                    .edgesIgnoringSafeArea(.horizontal)

                HStack(alignment: .center) {
                    VStack {
                        Image(systemName: "cloud.sun.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 14, height: UIScreen.main.bounds.width / 14)
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
                            .frame(width: UIScreen.main.bounds.width / 14, height: UIScreen.main.bounds.width / 14)
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
                            .frame(width: UIScreen.main.bounds.width / 14, height: UIScreen.main.bounds.width / 14)
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
                            .frame(width: UIScreen.main.bounds.width / 14, height: UIScreen.main.bounds.width / 14)
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
                .frame(height: UIScreen.main.bounds.height / 64)
                .offset(y: UIScreen.main.bounds.height / 256 * -1)
            }
            .opacity(addPressed ? 0.5: 1)
            .blur(radius: addPressed ? 1: 0)
            .onAppear(perform: defaultGetGym)
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
                                    if user.user.count > 0 {
                                        if returnData.count == 0 {
                                            if user.user.count > 0 {
                                                postGym("\(user.user[0].id)", getTimeComponents(currDate), ["\(activity)"], [false])
                                                addPressed = false
                                                activity = ""
                                                dataGetGym()
                                            }
                                        }
                                        else {
                                            returnData[0].activity.append(activity)
                                            returnData[0].completion.append(false)
                                            putGym("\(user.user[0].id)", getTimeComponents(currDate), returnData[0].activity, returnData[0].completion)
                                            addPressed = false
                                            activity = ""
                                            dataGetGym()
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
