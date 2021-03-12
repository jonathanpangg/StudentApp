//
//  ActivityData.swift
//  StudentApp
//
//  Created by Jonathan Pang on on 2/17/21.
//

import SwiftUI

struct ActivityData: Codable, Equatable {
    var id: String = ""
    var date: String = ""
    var activity: [String] = []
    var completion: [Bool] = []
    var completionPercentage: Double = 0
}
