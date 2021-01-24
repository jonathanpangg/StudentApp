//
//  RestaurantInfoView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/22/21.
//

import SwiftUI

struct RestaurantInfoView: View {
    @ObservedObject var pass: Pass
    
    func getArray(_ array: [RestaurantElement]) -> [String] {
        var list = [String]()
        for i in array {
            list.append("\(String(describing: i.restaurant!.location?.address ?? ""))")
        }
        return list
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        withAnimation {
                            pass.currentScreen = 1
                        }
                    }
                Spacer()
            }
            .padding()
            
            Text(getArray(pass.foodData.restaurants ?? [])[pass.index])
            Spacer()
        }
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}
