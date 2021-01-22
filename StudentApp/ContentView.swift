//
//  ContentView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/20/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var screen = Screen()
    
    var body: some View {
        switch screen.currentScreen {
        case 1:
            FoodView(screen: screen)
        default:
            WeatherView(screen: screen)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

