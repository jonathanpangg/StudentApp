//
//  GymData.swift
//  StudentApp
//
//  Created by Jonathan Pang on 2/17/21.
//

import SwiftUI

struct GymData: Codable, Equatable {
    var id: String = ""
    var date: String = ""
    var activity: [String] = []
    var completion: [Bool] = []
    var completionPercentage: Double = 0
    
}
