//
//  SignupView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/31/21.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var pass: Pass
    @ObservedObject var mode = ThemeStatus()
    @ObservedObject var user = joinUser()
    @State var users = [User]()
    @State var id = UUID()
    @State var firstName = ""
    @State var lastName = ""
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
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
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            print(data)
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                print(decoded)
                users = decoded
            }
        }.resume()
    }
    
    func postUser() {
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/users/\(id)/\(firstName)/\(lastName)/\(username)/\(password)/\(Date().timeIntervalSince1970)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        let params = [
            "id": "\(id)",
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "password": password,
            "date": "\(Date().timeIntervalSince1970)"
        ] 
        guard let encoded = try? JSONEncoder().encode(params) else { return }
        request.httpBody = encoded
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                if let _ = try? JSONDecoder().decode([User].self, from: data) { }
            }
        }.resume()
    }
    
    func verifyUsername() -> Bool {
        if username.count < 8 {
            return false
        }
        for user in users {
            if user.username == username {
                return false
            }
        }
        return true
    }
    
    // makes sure the password has any 2 combinations of letters, digits, or special symbols
    func subVerificationPassword(_ password: String) -> Bool {
        var pass = 0
        var verifications = ["letters": false, "digits": false, "special": false]
        for character in password.unicodeScalars {
            if !verifications["letters"]! {
                if CharacterSet.letters.contains(character) {
                    pass += 1
                    verifications["letters"] = true
                }
            }
            if !verifications["digits"]! {
                if CharacterSet.decimalDigits.contains(character) {
                    pass += 1
                    verifications["digits"] = true
                }
            }
            if !verifications["special"]! {
                if !CharacterSet.letters.contains(character) && !CharacterSet.letters.contains(character) {
                    pass += 1
                    verifications["special"] = true
                }
            }
            if pass >= 2 {
                return true
            }
        }
        return false
    }
    
    // checks if the user can signup with their password
    func verifyPassword() -> Bool {
        if password != confirmPassword {
            return false
        }
        if password.count < 8 || confirmPassword.count < 8 {
            return false
        }
        if (subVerificationPassword(password) && subVerificationPassword(confirmPassword)) == false {
            return false
        }
        return true
    }
    
    var body: some View {
        ZStack {
            getBackground()
                .ignoresSafeArea(.all)
            VStack {
                ZStack {
                    LoginTile(UIScreen.main.bounds.width / 8 * 7, UIScreen.main.bounds.height / 16 * 7, getBackground())
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.height / 48) {
                        HStack {
                            Text("First Name:")
                                .foregroundColor(getForeground())
                            Spacer()
                            Text("Last Name:")
                                .foregroundColor(getForeground())
                                .offset(x: UIScreen.main.bounds.width / 64)
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 48)
                        
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(getForeground(), lineWidth: 1)
                                    .frame(width: UIScreen.main.bounds.width / 8 * 3, height: UIScreen.main.bounds.height / 24)
                                TextField("", text: $firstName)
                                    .foregroundColor(getForeground())
                                    .frame(width: UIScreen.main.bounds.width / 16 * 5, height: UIScreen.main.bounds.height / 24)
                            }
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(getForeground(), lineWidth: 1)
                                    .frame(width: UIScreen.main.bounds.width / 8 * 3, height: UIScreen.main.bounds.height / 24)
                                TextField("", text: $lastName)
                                    .foregroundColor(getForeground())
                                    .frame(width: UIScreen.main.bounds.width / 16 * 5, height: UIScreen.main.bounds.height / 24)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 48)
                        
                        HStack {
                            Text("Username:")
                                .foregroundColor(getForeground())
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 48)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(getForeground(), lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 24)
                            TextField("", text: $username)
                                .autocapitalization(.none)
                                .font(.system(size: 16))
                                .foregroundColor(getForeground())
                                .multilineTextAlignment(.leading)
                                .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                        }
                        .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 48)
                        
                        HStack {
                            Text("Password:")
                                .foregroundColor(getForeground())
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 48)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(getForeground(), lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                            HStack {
                                SecureField("", text: $password)
                                    .autocapitalization(.none)
                                    .font(.system(size: 16))
                                    .foregroundColor(getForeground())
                                    .multilineTextAlignment(.leading)
                                    .frame(width: UIScreen.main.bounds.width / 16 * 9, height: UIScreen.main.bounds.height / 24)
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width / 16 * 11, height: UIScreen.main.bounds.height / 24)
                        }
                        .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 48)
                        
                        HStack {
                            Text("Confirm Password:")
                                .foregroundColor(getForeground())
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 48)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(getForeground(), lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                            HStack {
                                if secure {
                                    SecureField("", text: $confirmPassword)
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
                                    TextField("", text: $confirmPassword)
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
                        .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 48)
                    }
                }
                HStack {
                    ZStack {
                        LoginTile(UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 30, getBackground())
                        Text("Log into your account")
                            .foregroundColor(getForeground())
                            .onTapGesture {
                                pass.currentScreen = 4
                            }
                    }
                    Spacer()
                    ZStack {
                        LoginTile(UIScreen.main.bounds.width / 5, UIScreen.main.bounds.height / 30, getBackground())
                        Text("Signup")
                            .foregroundColor(getForeground())
                            .onTapGesture {
                                if verifyUsername() && verifyPassword() {
                                    if let encoded = try? JSONEncoder().encode(user.user) {
                                        UserDefaults.standard.set(encoded, forKey: "saveUser")
                                    }
                                    postUser()
                                    pass.currentScreen = 0
                                }
                                else {
                                    alertStatus = true
                                }
                            }
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 24)
            }
            .alert(isPresented: $alertStatus) {
                Alert(title: Text("Unable to Signup"), message: nil, dismissButton: .default(Text("Try Again")))
            }
        }
    }
}
