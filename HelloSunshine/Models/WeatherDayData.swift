//
//  WeatherDayData.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import Foundation

struct WeatherDayData: Decodable {

    // MARK: - Properties
    
    let time: Date
    let icon: String
    let windSpeed: Double
    let temperatureMin: Double
    let temperatureMax: Double

    init() {
        time = Date()
        icon = ""
        windSpeed = 0.0
        temperatureMin = 0.0
        temperatureMax = 0.0
    }
}

