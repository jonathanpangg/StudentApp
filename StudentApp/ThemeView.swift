//
//  ThemeView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/27/21.
//

import SwiftUI

struct ThemeView: View {
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
            VStack {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(getForeground())
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
                        .padding(.trailing)
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
                        .padding(.trailing)
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
                        .padding(.trailing)
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
}
