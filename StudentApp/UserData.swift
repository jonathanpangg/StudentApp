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

func LoginTile(_ username: Binding<String>, _ width: CGFloat, _ height: CGFloat, _ background: Color, _ foreground: Color, _ fontSize: CGFloat = 14, _ fontWeight: Font.Weight = .regular) -> some View {
    ZStack {
        Text("")
            .multilineTextAlignment(.leading)
            .font(.system(size: fontSize, weight: fontWeight))
            .foregroundColor(foreground)
            .frame(width: width, height: height)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: UIScreen.main.bounds.width / 16 * 12, height: UIScreen.main.bounds.height / 24)
                TextField("", text: username)
            }
        }
        .frame(width: width - width / 8, height: height - height / 8)
    }}
