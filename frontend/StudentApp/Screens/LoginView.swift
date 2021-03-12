//
//  LoginView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/31/21.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var pass: Pass
    @ObservedObject var mode = ThemeStatus()
    @ObservedObject var join = joinUser()
    @State var users = [User]()
    @State var user = User()
    @State var username = ""
    @State var password = ""
    @State var secure = true
    @State var alertStatus = false
    @State var screenAppear = false
    
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
    
    func autoLog() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if join.user.count > 0 {
                if Double(Date().timeIntervalSince1970) - Double(join.user[0].date)! > 604800 {
                    pass.currentScreen = 4
                }
                else {
                    pass.currentScreen = 0
                }
            }
            screenAppear = true
        }
    }
    
    func verifyUser() -> Bool {
        var count = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            while (count < 5 || users.count != 1) {
                count += 1
            }
        }
        if users.count == 1 {
            return true
        }
        return false
    }
    
    func getSpecificUser() {
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/users/\(username)/\(password)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                DispatchQueue.main.async {
                    users = decoded
                    join.user = users
                    if users.count > 0 {
                        join.user[0].date = "\(Date().timeIntervalSince1970)"
                        putUser(users[0].id, "\(Date().timeIntervalSince1970)")
                    }
                }
            }
        }.resume()
    }
    
    func putUser(_ id: String, _ newDate: String) {
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/users/\(id)/\(newDate)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                DispatchQueue.main.async {
                    users = decoded
                }
            }
        }.resume()
    }
    
    var body: some View {
        ZStack {
            getBackground()
                .ignoresSafeArea(.all)
            
            VStack {
                if screenAppear {
                    HStack {
                        Text("Login")
                            .font(.system(size: UIScreen.main.bounds.width / 8, weight: .bold, design: .default))
                            .foregroundColor(getForeground())
                            .padding(.leading)
                        Spacer()
                    }
                    Spacer()
                    
                    ZStack {
                        LoginTile(UIScreen.main.bounds.width / 8 * 7, UIScreen.main.bounds.height / 4, getBackground())
                        VStack {
                            HStack {
                                Text("Username:")
                                    .foregroundColor(getForeground())
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 48)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(getForeground(), lineWidth: 1)
                                     .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                                TextField("", text: $username)
                                    .autocapitalization(.none)
                                    .font(.system(size: 16))
                                    .foregroundColor(getForeground())
                                    .multilineTextAlignment(.leading)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                            }
                            
                            HStack {
                                Text("Password:")
                                    .foregroundColor(getForeground())
                                Spacer()
                            }
                            
                            .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 48)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(getForeground(), lineWidth: 1)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                                HStack {
                                    if secure {
                                        SecureField("", text: $password)
                                            .autocapitalization(.none)
                                            .font(.system(size: 16))
                                            .foregroundColor(getForeground())
                                            .multilineTextAlignment(.leading)
                                            .frame(width: UIScreen.main.bounds.width / 64 * 33, height: UIScreen.main.bounds.height / 24)
                                        Spacer()
                                        Image(systemName: "eye.fill")
                                            .foregroundColor(getForeground())
                                            .onTapGesture {
                                                withAnimation {
                                                    secure.toggle()
                                                }
                                            }
                                    }
                                    else {
                                        TextField("Password: ", text: $password)
                                            .autocapitalization(.none)
                                            .font(.system(size: 16))
                                            .foregroundColor(getForeground())
                                            .multilineTextAlignment(.leading)
                                            .frame(width: UIScreen.main.bounds.width / 16 * 9, height: UIScreen.main.bounds.height / 24)
                                        Spacer()
                                        Image(systemName: "eye.slash.fill")
                                            .foregroundColor(getForeground())
                                            .onTapGesture {
                                                withAnimation {
                                                    secure.toggle()
                                                }
                                            }
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                            }
                        }
                    }
                    
                    HStack(alignment: .center) {
                        ZStack {
                            LoginTile(UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 30, getBackground())
                            Text("Register an account")
                                .foregroundColor(getForeground())
                        }
                        .onTapGesture {
                            pass.currentScreen = 5
                        }
                        Spacer()
                        
                        ZStack {
                            LoginTile(UIScreen.main.bounds.width / 4, UIScreen.main.bounds.height / 30, getBackground())
                            Text("Login")
                                .foregroundColor(getForeground())
                        }
                        .onTapGesture {
                            getSpecificUser()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                if verifyUser() {
                                    if let encoded = try? JSONEncoder().encode(join.user) {
                                        UserDefaults.standard.setValue(encoded, forKey: "saveUser")
                                    }
                                    pass.currentScreen = 0
                                }
                                else {
                                    alertStatus = true
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width / 8 * 7)
                    Spacer()
                }
            }
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
            .onAppear(perform: autoLog)
            .alert(isPresented: $alertStatus) {
                Alert(title: Text("Unable to Login"), message: Text("Either your username or password is incorrect"), dismissButton: .default(Text("Retry")))
            }
        }
    }
}
