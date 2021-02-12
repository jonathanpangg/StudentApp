//
//  GeocodingData.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/20/21.
//

import SwiftUI

struct GeocodingData: Codable {
    let status, country, countryCode, region: String
    let regionName, city, zip: String
    let lat, lon: Double
    let timezone, isp, org, geocodingDataAs: String
    let query: String

    enum CodingKeys: String, CodingKey {
        case status, country, countryCode, region, regionName, city, zip, lat, lon, timezone, isp, org
        case geocodingDataAs = "as"
        case query
    }
    
    init() {
        self.status = ""
        self.country = ""
        self.countryCode = ""
        self.region = ""
        self.regionName = ""
        self.city = ""
        self.zip = ""
        self.lat = 0
        self.lon = 0
        self.timezone = ""
        self.isp = ""
        self.org = ""
        self.geocodingDataAs = ""
        self.query = ""
    }
}

struct ReverseGeo: Codable {
    let location: Locations
    
    init() { self.location = Locations() }
}

struct Locations: Codable {
    let entity_type: String
    let entity_id: Int
    let title, latitude, longitude: String
    let city_id: Int
    let city_name: String
    let country_id: Int
    let country_name: String
    
    init() {
        self.entity_type = ""
        self.entity_id = 0
        self.title = ""
        self.latitude = ""
        self.longitude = ""
        self.city_id = 0
        self.city_name = ""
        self.country_id = 0
        self.country_name = ""
        
    }
}
