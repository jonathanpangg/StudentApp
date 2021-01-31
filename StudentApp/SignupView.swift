//
//  SignupView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/31/21.
//

import SwiftUI

struct SignupView: View {
    @State var id = UUID()
    @State var firstName = ""
    @State var lastName = ""
    @State var username = ""
    @State var password = ""
    
    func postUser() {
        guard let url = URL(string: "http://localhost:1000/users/\(id)/\(firstName)/\(lastName)/\(username)/\(password)/\(Date().timeIntervalSince1970)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        let params = [
            "id": "\(id)",
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "password": password,
            "date": "\(Date().timeIntervalSince1970)"
        ] 
        guard let encoded = try? JSONEncoder().encode(params) else { return }
        request.httpBody = encoded
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                print(data)
                if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                    print(decoded)
                }
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            TextField("First Name: ", text: $firstName)
            TextField("Last Name: ", text: $lastName)
            TextField("username: ", text: $username)
            TextField("Password: ", text: $password)
            Button("Press") {
                id = UUID()
                postUser()
            }
        }
    }
}
