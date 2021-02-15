//
//  GymView.swift
//  StudentApp
//
//  Created by Jonathan Pang on 2/15/21.
//

import SwiftUI

struct GymView: View {
    func postGym(_ id: String, _ acitivites: [String], _ completion: [Bool]) {
        let activityQuery = "\(acitivites)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let completionQuery = "\(completion)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(id)/\(activityQuery)/\(completionQuery)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        let body = [
            "id": id,
            "activity": acitivites,
            "completion": completion
        ] as [String: Any]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else { return }
        }.resume()
    }

    func putGym(_ id: String, _ oldActivities: [String], _ newActivities: [String], _ oldCompletion: [Bool], _ newCompletion: [Bool]) {
        let oldActivityQuery = "\(oldActivities)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let newActivityQuery = "\(newActivities)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let oldCompletionQuery = "\(oldCompletion)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let newCompletionQuery = "\(newCompletion)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://heroku-student-app.herokuapp.com/gym/\(id)/\(oldActivityQuery)/\(newActivityQuery)/\(oldCompletionQuery)/\(newCompletionQuery)") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else { return }
        }.resume()
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        GymView()
    }
}
