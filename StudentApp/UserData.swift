//
//  UserData.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/31/21.
//

import SwiftUI

struct User: Codable, Hashable {
    var _id, id, firstName, lastName, username, password, date: String
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
