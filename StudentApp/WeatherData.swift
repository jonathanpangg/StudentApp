//
//  WeatherData.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/20/21.
//

import SwiftUI

struct WeatherData: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
    init() {
        self.coord = Coord()
        self.weather = [Weather]()
        self.base = ""
        self.main = Main()
        self.visibility = 0
        self.wind = Wind()
        self.clouds = Clouds()
        self.dt = 0
        self.sys = Sys()
        self.timezone = 0
        self.id = 0
        self.name = ""
        self.cod = 0
    }
}

struct Clouds: Codable {
    let all: Int
    
    init() {
        self.all = 0
    }
}

struct Coord: Codable {
    let lon, lat: Double
    
    init() {
        self.lon = 0
        self.lat = 0
    }
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin   = "temp_min"
        case tempMax   = "temp_max"
        case pressure, humidity
    }
    
    init() {
        self.temp = 255.5
        self.feelsLike = 0
        self.tempMin = 0
        self.tempMax = 0
        self.pressure = 0
        self.humidity = 0
    }
}

struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
    
    init() {
        self.type = 0
        self.id = 0
        self.country = ""
        self.sunrise = 0
        self.sunset = 0
    }
}

struct Weather: Codable, Hashable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    init() {
        self.id = 0
        self.main = ""
        self.weatherDescription = ""
        self.icon = ""
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    
    init() {
        self.speed = 0
        self.deg = 0
    }
}
