//
//  UserData.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/31/21.
//

import SwiftUI

struct User: Codable, Hashable {
    var _id, id, firstName, lastName, username, password, date: String
    
    init() {
        self._id = ""
        self.id = ""
        self.firstName = ""
        self.lastName = ""
        self.username = ""
        self.password = ""
        self.date = ""
    }
}

func LoginTile(_ width: CGFloat, _ height: CGFloat, _ background: Color) -> some View {
    ZStack {
        Text("")
            .multilineTextAlignment(.leading)
            .frame(width: width, height: height)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
    }
}

class joinUser: ObservableObject {
    @Published var user: User
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "saveUser") {
            if let decoded = try? JSONDecoder().decode(User.self, from: data) {
                self.user = decoded
                return
            }
        }
        self.user = User()
    }
}
