//
//  ContentView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/20/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pass = Pass()
    @State var weatherData = WeatherData()
    
    var body: some View {
        /*
        switch pass.currentScreen {
        case 1:
            FoodView(pass: pass)
        case 2:
            SettingView(pass: pass)
        case 3:
            ThemeView(pass: pass)
        default:
            WeatherView(pass: pass)
        }
        */
        // LoginView()
        SignupView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

