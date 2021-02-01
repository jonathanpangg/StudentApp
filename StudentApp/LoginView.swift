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
    @State var users = [User]()
    @State var username = ""
    @State var password = ""
    @State var secure = true
    @State var alertStatus = false

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
    
    func getUser() {
        guard let url = URL(string: "http://localhost:1000/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            print(data)
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                users = decoded
            }
        }.resume()
    }
    
    func verifyUser() -> Bool {
        for user in users {
            if user.username == username && user.password == password {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        ZStack {
            getBackground()
                .ignoresSafeArea(.all)
            VStack {
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
                        if verifyUser() {
                            pass.currentScreen = 0
                        }
                        else {
                            alertStatus = true
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 8 * 7)
            }
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
            .onAppear(perform: getUser)
            .alert(isPresented: $alertStatus) {
                Alert(title: Text("Unable to Login"), message: Text("Either your username or password is incorrect"), dismissButton: .default(Text("Retry")))
            }
        }
    }
}
