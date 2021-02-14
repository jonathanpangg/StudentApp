//
//  SettingView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/27/21.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var pass: Pass
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var mode = ThemeStatus()
    @ObservedObject var status = NotificationStatus()
    @ObservedObject var join = joinUser()
    @State var expandThemes = false
    @State var expandNotification = false
    @State var pressedSignOut = false
    
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
    
    var body: some View {
        ZStack {
            getBackground()
                .ignoresSafeArea(.all)
            VStack(alignment: .center) {
                HStack {
                    Text("Themes")
                        .foregroundColor(getForeground())
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(getForeground())
                        .rotationEffect(.degrees(expandThemes ? 90 : 0))
                        .animation(.easeInOut)
                }
                .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7)
                .background(getBackground())
                .onTapGesture {
                    withAnimation {
                        expandThemes.toggle()
                    }
                }
                .padding(.top)
                Divider()
                    .frame(width: UIScreen.main.bounds.width / 8 * 7)
                
                if expandThemes {
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Light Mode")
                                    .foregroundColor(getForeground())
                                Spacer()
                                ZStack {
                                    if mode.mode.mode == "Light" {
                                        Circle()
                                            .fill()
                                            .foregroundColor(Color.blue)
                                            .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32)
                                    }
                                    Circle()
                                        .stroke(getForeground(), lineWidth: 1)
                                        .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                            Divider()
                                .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7)
                    .background(getBackground())
                    .onTapGesture {
                        mode.mode.mode = "Light"
                        if let encoded = try? JSONEncoder().encode(mode.mode) {
                            UserDefaults.standard.set(encoded, forKey: "save")
                        }
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Dark Mode")
                                    .foregroundColor(getForeground())
                                Spacer()
                                ZStack {
                                    if mode.mode.mode == "Dark" {
                                        Circle()
                                            .fill()
                                            .foregroundColor(Color.blue)
                                            .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32)
                                    }
                                    Circle()
                                        .stroke(getForeground(), lineWidth: 1)
                                        .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                            Divider()
                                .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7)
                    .background(getBackground())
                    .onTapGesture {
                        mode.mode.mode = "Dark"
                        if let encoded = try? JSONEncoder().encode(mode.mode) {
                            UserDefaults.standard.set(encoded, forKey: "save")
                        }
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("System Mode")
                                    .foregroundColor(getForeground())
                                Spacer()
                                ZStack {
                                    if mode.mode.mode == "Default" {
                                        Circle()
                                            .fill()
                                            .foregroundColor(Color.blue)
                                            .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32)
                                    }
                                    Circle()
                                        .stroke(getForeground(), lineWidth: 1)
                                        .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                            Divider()
                                .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7)
                    .background(getBackground())
                    .onTapGesture {
                        mode.mode.mode = "Default"
                        if let encoded = try? JSONEncoder().encode(mode.mode) {
                            UserDefaults.standard.set(encoded, forKey: "save")
                        }
                    }
                }
                
                HStack {
                    Text("Notifications")
                        .foregroundColor(getForeground())
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(getForeground())
                        .rotationEffect(.degrees(expandNotification ? 90 : 0))
                        .animation(.easeInOut)
                    
                }
                .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7)
                .background(getBackground())
                .onTapGesture {
                    withAnimation {
                        expandNotification.toggle()
                    }
                }
                Divider()
                    .frame(width: UIScreen.main.bounds.width / 8 * 7)
                
                if expandNotification {
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Enable Notifications")
                                    .foregroundColor(getForeground())
                                Spacer()
                                ZStack {
                                    if status.status.status == "ON" {
                                        Circle()
                                            .fill()
                                            .foregroundColor(Color.blue)
                                            .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32)
                                    }
                                    Circle()
                                        .stroke(getForeground(), lineWidth: 1)
                                        .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                            Divider()
                                .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7)
                    .background(getBackground())
                    .onTapGesture {
                        status.status.status = "ON"
                        if let encoded = try? JSONEncoder().encode(status.status) {
                            UserDefaults.standard.set(encoded, forKey: "status")
                        }
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Disable Notifications")
                                    .foregroundColor(getForeground())
                                Spacer()
                                ZStack {
                                    if status.status.status == "NO" {
                                        Circle()
                                            .fill()
                                            .foregroundColor(Color.blue)
                                            .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32)
                                    }
                                    Circle()
                                        .stroke(getForeground(), lineWidth: 1)
                                        .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                            Divider()
                                .frame(width: UIScreen.main.bounds.width / 8 * 6 - UIScreen.main.bounds.width / 64 * 6)
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7)
                    .background(getBackground())
                    .onTapGesture {
                        status.status.status = "NO"
                        if let encoded = try? JSONEncoder().encode(status.status) {
                            UserDefaults.standard.set(encoded, forKey: "status")
                        }
                    }
                }
                
                HStack {
                    Text("Sign Out")
                        .foregroundColor(getForeground())
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7)
                .background(getBackground())
                .onTapGesture {
                    withAnimation {
                        pressedSignOut = true
                    }
                }
                Divider()
                    .frame(width: UIScreen.main.bounds.width / 8 * 7)

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
            .opacity(pressedSignOut ? 0.5: 1)
            .blur(radius: pressedSignOut ? 1: 0)
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
            if pressedSignOut {
                ZStack {
                    Text("")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(getForeground())
                        .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                        .background(getBackground())
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                    VStack {
                        Text("Are you sure you want to sign out?")
                            .multilineTextAlignment(.center)
                            .foregroundColor(getForeground())
                        Spacer()
                        Divider()
                        HStack(alignment: .center) {
                            HStack(alignment: .center) {
                                Text("Yes")
                                    .foregroundColor(getForeground())
                            }
                            .frame(width: (UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 16) / 2)
                            .onTapGesture {
                                withAnimation {
                                    join.user = [User]()
                                    if let encoded = try? JSONEncoder().encode(join.user) {
                                        UserDefaults.standard.setValue(encoded, forKey: "saveUser")
                                    }
                                    pass.currentScreen = 4
                                }
                            }
                            Spacer()
                            
                            HStack(alignment: .center) {
                                Text("No")
                                    .foregroundColor(getForeground())
                            }
                            .frame(width: (UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 16) / 2)
                            .onTapGesture {
                                withAnimation {
                                    pressedSignOut = false
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

class ThemeStatus: ObservableObject {
    @Published var mode = ThemeData()
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "save") {
            if let decoded = try? JSONDecoder().decode(ThemeData.self, from: data) {
                self.mode = decoded
                return
            }
        }
    }
}


struct ThemeData: Codable {
    var mode: String
    
    init() { self.mode = "" }
}

class NotificationStatus: ObservableObject {
    @Published var status = NotificationData()
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "status") {
            if let decoded = try? JSONDecoder().decode(NotificationData.self, from: data) {
                self.status = decoded
                return
            }
        }
    }
}

struct NotificationData: Codable {
    var status: String
    
    init() { self.status = "" }
}
