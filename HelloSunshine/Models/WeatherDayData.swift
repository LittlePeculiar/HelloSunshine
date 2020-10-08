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
    
    
    // MARK: computed props
    
    public var dayLabelText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: time)
    }
    
    public var dateLabelText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: time)
    }
    
    public var temperatureLabelText: String {

        var min = temperatureMin
        var max = temperatureMax
        if UserDefaults.temperatureNotation != .fahrenheit {
            min = temperatureMin.toCelcius
            max = temperatureMax.toCelcius
        }
        let minStr = String(format: "%.0f°", min)
        let maxStr = String(format: "%.0f°", max)
        return "\(minStr) - \(maxStr)"
    }
    
    public var windSpeedLabelText: String {
        if UserDefaults.unitsNotation != .imperial {
            return String(format: "%.f KPH", windSpeed.toKPH)
        } else {
            return String(format: "%.f MPH", windSpeed)
        }
    }
}

