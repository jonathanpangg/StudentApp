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
                HStack(alignment: .center) {
                    ZStack {
                        Text("")
                            .multilineTextAlignment(.leading)
                            .frame(width: UIScreen.main.bounds.width / 8 * 7, height: UIScreen.main.bounds.height / 16)
                            .background(getBackground())
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
                        HStack {
                            Text("Themes")
                                .foregroundColor(getForeground())
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(getForeground())
                        }
                        .frame(width: UIScreen.main.bounds.width / 8 * 7 - UIScreen.main.bounds.width / 64 * 7, height: UIScreen.main.bounds.height / 16 - UIScreen.main.bounds.height / 16 / 8)
                        .background(getBackground())
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                        .onTapGesture {
                            pass.currentScreen = 3
                        }
                    }
                    Spacer()
                }
                .background(getBackground())
                .padding()
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
                        Image(systemName: "gear")
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
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
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
