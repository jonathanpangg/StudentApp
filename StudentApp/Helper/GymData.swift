//
//  GymData.swift
//  StudentApp
//
//  Created by Jonathan Pang on 2/17/21.
//

import SwiftUI

struct GymData: Codable, Equatable {
    let id: String
    let date: String
    var activity: [String]
    var completion: [Bool]
}
