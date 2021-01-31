//
//  LoginView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/31/21.
//

import SwiftUI

struct LoginView: View {
    @State var users = [User]()

    func getUser() {
        guard let url = URL(string: "http://localhost:1000/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            print(data)
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                print(decoded)
                users = decoded
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            Button("Press") {
                getUser()
            }
            ForEach(users, id: \.self) { user in
                Text(user.firstName)
            }
        }
    }
}
