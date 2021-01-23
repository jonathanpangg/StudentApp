//
//  RestaurantInfoView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/22/21.
//

import SwiftUI

struct RestaurantInfoView: View {
    @ObservedObject var screen: Screen
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        withAnimation {
                            screen.currentScreen = 1
                        }
                    }
                    .offset(x: UIScreen.main.bounds.width / 64 * 3, y: UIScreen.main.bounds.width / 64 * 3)
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}
