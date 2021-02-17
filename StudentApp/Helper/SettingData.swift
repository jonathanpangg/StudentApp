//
//  SettingData.swift
//  StudentApp
//
//  Created by Jonathan Pang on 2/17/21.
//

import SwiftUI

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
