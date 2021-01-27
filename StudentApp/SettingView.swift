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
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    ZStack {
                        Text("")
                            .multilineTextAlignment(.leading)
                            .frame(width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 16)
                            .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                        HStack {
                            Text("Themes")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7, height: UIScreen.main.bounds.height / 16 - UIScreen.main.bounds.height / 16 / 8)
                        .background(colorScheme != .dark ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .onTapGesture {
                            withAnimation {
                                pass.currentScreen = 3
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }
            .padding()
            
            HStack(alignment: .center) {
                VStack {
                    Image(systemName: "cloud.sun.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                    Text("Weather")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 12))
                }
                .onTapGesture {
                    withAnimation {
                        pass.currentScreen = 0
                    }
                }
                .offset(x: UIScreen.main.bounds.width / 64 * 3)
                .padding()
                Spacer()
                
                VStack {
                    Image(systemName: "bag.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                    Text("Restaurants")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 12))
                }
                .onTapGesture {
                    withAnimation {
                        pass.currentScreen = 1
                    }
                }
                .padding()
                Spacer()
                
                VStack {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                    Text("Settings")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 12))
                }
                .onTapGesture {
                    withAnimation {
                        pass.currentScreen = 2
                    }
                }
                .offset(x: UIScreen.main.bounds.width / 64 * -3)
                .padding()
            }
            .frame(height: UIScreen.main.bounds.height / 64 * 2)
            .offset(y: UIScreen.main.bounds.height / 256 * -1)
        }
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

struct ThemeView: View {
    @ObservedObject var mode = ThemeStatus()
    @ObservedObject var pass: Pass
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                Spacer()
            }
            .padding(.leading)
            .onTapGesture {
                withAnimation {
                    pass.currentScreen = 2
                }
            }
            ScrollView(.vertical) {
                HStack {
                    Text("Light Mode")
                    Spacer()
                    ZStack {
                        if mode.mode.mode == "Light" {
                            Circle()
                                .fill()
                                .foregroundColor(Color.blue)
                                .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32)
                        }
                        Circle()
                            .stroke(lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        mode.mode.mode = "Light"
                        if let encoded = try? JSONEncoder().encode(mode.mode) {
                            UserDefaults.standard.set(encoded, forKey: "save")
                        }
                    }
                }
                HStack {
                    Text("Dark Mode")
                    Spacer()
                    ZStack {
                        if mode.mode.mode == "Dark" {
                            Circle()
                                .fill()
                                .foregroundColor(Color.blue)
                                .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32)
                        }
                        Circle()
                            .stroke(lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        mode.mode.mode = "Dark"
                        if let encoded = try? JSONEncoder().encode(mode.mode) {
                            UserDefaults.standard.set(encoded, forKey: "save")
                        }
                    }
                }
                HStack {
                    Text("System Mode")
                    Spacer()
                    ZStack {
                        if mode.mode.mode == "Default" {
                            Circle()
                                .fill()
                                .foregroundColor(Color.blue)
                                .frame(width: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 16 - UIScreen.main.bounds.width / 32)
                        }
                        Circle()
                            .stroke(lineWidth: 1)
                            .frame(width: UIScreen.main.bounds.width / 16, height: UIScreen.main.bounds.width / 16)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        mode.mode.mode = "Default"
                        if let encoded = try? JSONEncoder().encode(mode.mode) {
                            UserDefaults.standard.set(encoded, forKey: "save")
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
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
