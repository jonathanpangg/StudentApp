//
//  ActivitiesView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 2/15/21.
//

import SwiftUI

struct ActivitiesView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var pass: Pass
    @ObservedObject var mode = ThemeStatus()
    @ObservedObject var user = joinUser()
    @State var returnData = [ActivityData]()
    @State var weekData = [ActivityData(), ActivityData(), ActivityData(), ActivityData(), ActivityData(), ActivityData(), ActivityData()]
    @State var trend = false
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
    func getDayOfWeek(_ date: Date) -> (String, Int) {
        let toStringFormatter = DateFormatter()
        toStringFormatter.dateStyle = .short
        let toDayOfWeekFormatter = DateFormatter()
        toDayOfWeekFormatter.dateFormat = "MM/dd/yy"
        guard let todayDate = toDayOfWeekFormatter.date(from: toStringFormatter.string(from: date)) else { return ("", 10) }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        switch weekDay {
        case 1:
            return ("Sun", weekDay)
        case 2:
            return ("Mon", weekDay)
        case 3:
            return ("Tues", weekDay)
        case 4:
            return ("Wed", weekDay)
        case 5:
            return ("Thurs", weekDay)
        case 6:
            return ("Fri", weekDay)
        default:
            return ("Sat", 0)
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
    
    func updateValues(_ currDay: Int) {
        DispatchQueue.main.async {
            if currDay < 1 {
                getValueActivity(Date().addingTimeInterval(86400 * (Double(currDay) - 1)))
            }
            else {
                getValueActivity(Date().addingTimeInterval(86400 * (1 - Double(currDay))))
            }
            if currDay < 2 {
                getValueActivity(Date().addingTimeInterval(86400 * (Double(currDay) - 2)))
            }
            else {
                getValueActivity(Date().addingTimeInterval(86400 * (2 - Double(currDay))))
            }
            if currDay < 3 {
                getValueActivity(Date().addingTimeInterval(86400 * (Double(currDay) - 3)))
            }
            else {
                getValueActivity(Date().addingTimeInterval(86400 * (3 - Double(currDay))))
            }
            if currDay < 4 {
                getValueActivity(Date().addingTimeInterval(86400 * (Double(currDay) - 4)))
            }
            else {
                getValueActivity(Date().addingTimeInterval(86400 * (4 - Double(currDay))))
            }
            if currDay < 5 {
                getValueActivity(Date().addingTimeInterval(86400 * (Double(currDay) - 5)))
            }
            else {
                getValueActivity(Date().addingTimeInterval(86400 * (5 - Double(currDay))))
            }
            if currDay < 6 {
                getValueActivity(Date().addingTimeInterval(86400 * (Double(currDay) - 6)))
            }
            else {
                getValueActivity(Date().addingTimeInterval(86400 * (6 - Double(currDay))))
            }
            getValueActivity(Date().addingTimeInterval(86400 * (7 - Double(currDay))))
        }
    }
    
    func defaultGetActivity() {
        let (_, curr) = getDayOfWeek(Date())
        if user.user.count > 0 {
            guard let url = URL(string: "https://heroku-student-app.herokuapp.com/Activity/\(user.user[0].id)/\(getTimeComponents(currDate))") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([ActivityData].self, from: data) {
                    DispatchQueue.main.async {
                        returnData = decoded
                        updateValues(curr)
                    }
                }
            }.resume()
        }
    }
    
    func dataGetActivity() {
        let (_, curr) = getDayOfWeek(Date())
        if user.user.count > 0 {
            guard let url = URL(string: "https://heroku-student-app.herokuapp.com/Activity/\(user.user[0].id)/\(getTimeComponents(currDate))") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([ActivityData].self, from: data) {
                    let pastValue = returnData
                    for _ in 0..<10 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            returnData = decoded
                            if returnData != pastValue {
                                updateValues(curr)
                                return
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    func getValueActivity(_ date: Date) {
        if user.user.count > 0 {
            let (_, currDay) = getDayOfWeek(date)
            guard let url = URL(string: "https://heroku-student-app.herokuapp.com/Activity/\(user.user[0].id)/\(getTimeComponents(date))") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if let decoded = try? JSONDecoder().decode([ActivityData].self, from: data) {
                    for _ in 0..<10 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if decoded.count > 0 {
                                weekData[currDay] = decoded[0]
                                return
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    func postActivity(_ id: String, _ date: String, _ activites: [String], _ completion: [Bool], _ completionPercentage: Double) {
        let activityQuery = "\(activites)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let completionQuery = "\(completion)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/Activity/\(id)/\(date)/\(activityQuery)/\(completionQuery)/\(completionPercentage)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        let body = [
            "id": id,
            "date": date,
            "activity": activites,
            "completion": completion,
            "completionPercentage": completionPercentage
        ] as [String: Any]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else { return }
            DispatchQueue.main.async {
                dataGetActivity()
            }
        }.resume()
    }
    
    
    func putActivity(_ id: String, _ date: String, _ newActivities: [String], _ newCompletion: [Bool], _ completionPercentage: Double) {
        deleteActivity(id, date)
        if newActivities.count > 0 || newCompletion.count > 0 {
            postActivity(id, date, newActivities, newCompletion, completionPercentage)
        }
    }
    
    func deleteActivity(_ id: String, _ date: String) {
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/Activity/\(id)/\(date)") else { return }
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
                let (currDay, _) = getDayOfWeek(currDate)
                let (_, curr) = getDayOfWeek(Date())
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
                            withAnimation(.linear) {
                                if !trend {
                                    addPressed = true
                                }
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
                            dataGetActivity()
                        }
                    Text("\(currDay) \(getDay(currDate))")
                        .font(.largeTitle)
                        .frame(width: UIScreen.main.bounds.width / 16 * 7)
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .onTapGesture {
                            increment += 1
                            currDate = Date().addingTimeInterval(TimeInterval(86400 * increment))
                            dataGetActivity()
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
                                                var amountOfTrue = 0
                                                for value in returnData[0].completion {
                                                    if value {
                                                        amountOfTrue += 1
                                                    }
                                                }
                                                returnData[0].completionPercentage = Double(amountOfTrue) / Double(returnData[0].completion.count)
                                                putActivity("\(user.user[0].id)", getTimeComponents(currDate), returnData[0].activity, returnData[0].completion, returnData[0].completionPercentage)
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
                                        var amountOfTrue = 0
                                        for value in returnData[0].completion {
                                            if value {
                                                amountOfTrue += 1
                                            }
                                        }
                                        returnData[0].completionPercentage = Double(amountOfTrue) / Double(returnData[0].completion.count)
                                        putActivity("\(user.user[0].id)", getTimeComponents(currDate), returnData[0].activity, returnData[0].completion, returnData[0].completionPercentage)
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
                
                HStack {
                    ZStack {
                        Text("")
                            .multilineTextAlignment(.leading)
                            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 24)
                            .background(getBackground())
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                        Text("Trends")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(getForeground())
                            .frame(width: UIScreen.main.bounds.width / 4 - UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.height / 24 - UIScreen.main.bounds.height / 24 / 4)
                    }
                    .onTapGesture {
                        if !addPressed {
                            withAnimation(.linear) {
                                updateValues(curr)
                                trend.toggle()
                            }
                        }
                    }
                    Spacer()
                }
                .offset(y: UIScreen.main.bounds.height / -24)
                .padding(.top)
                .padding(.leading)
                
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
                            .font(.caption)
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
                            .font(.caption)
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
                            .font(.caption)
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
                            .font(.caption)
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
            .blur(radius: addPressed || trend ? 1: 0)
            .onAppear(perform: defaultGetActivity)
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
                                                postActivity("\(user.user[0].id)", getTimeComponents(currDate), ["\(activity)"], [false], 0)
                                                withAnimation(.linear) {
                                                    addPressed = false
                                                }
                                                activity = ""
                                                dataGetActivity()
                                            }
                                        }
                                        else {
                                            returnData[0].activity.append(activity)
                                            returnData[0].completion.append(false)
                                            var amountOfTrue = 0
                                            for value in returnData[0].completion {
                                                if value {
                                                    amountOfTrue += 1
                                                }
                                            }
                                            returnData[0].completionPercentage = Double(amountOfTrue) / Double(returnData[0].completion.count)
                                            putActivity("\(user.user[0].id)", getTimeComponents(currDate), returnData[0].activity, returnData[0].completion, returnData[0].completionPercentage)
                                            withAnimation(.linear) {
                                                addPressed = false
                                            }
                                            activity = ""
                                            dataGetActivity()
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
            
            if trend {
                VStack {
                    HStack {
                        Text("Week of \(getMonth(Date())) \(getDay(Date()))")
                            .foregroundColor(getForeground())
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top)
                    .padding(.bottom)
                    
                    HStack(spacing: UIScreen.main.bounds.width / 32) {
                        Text("Sun")
                        Text("Mon")
                        Text("Tues")
                        Text("Wed")
                        Text("Thurs")
                        Text("Fri")
                        Text("Sat")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(getForeground())
                    .padding(.leading)
                    .padding(.trailing)
                    
                    HStack {
                        Path { path in
                            path.move(to: CGPoint(x: UIScreen.main.bounds.width / 150, y: CGFloat(175) - 175 * CGFloat(weekData[1].completionPercentage)))
                            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 9.8, y: CGFloat(175) - 175 * CGFloat(weekData[2].completionPercentage)))
                            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 5.1, y: CGFloat(175) - 175 * CGFloat(weekData[3].completionPercentage)))
                            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 3.31, y: CGFloat(175) - (175 * CGFloat(weekData[4].completionPercentage))))
                            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 2.45, y: CGFloat(175) - 175 * CGFloat(weekData[5].completionPercentage)))
                            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 1.975, y: CGFloat(175) - (175 * CGFloat(weekData[6].completionPercentage))))
                            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 1.725, y: CGFloat(175) - 175 * CGFloat(weekData[0].completionPercentage)))
                        }
                        .stroke(CGFloat(weekData[1].completionPercentage) > CGFloat(weekData[0].completionPercentage) ? Color.red: Color.green, lineWidth: 2)
                        .padding(.leading)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                    Spacer()
                }
                .background(getBackground())
                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.width / 4 * 3)
                .transition(.scale)
            }
        }
    }
}
