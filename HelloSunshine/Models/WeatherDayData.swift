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

        let isFahrenheit = UserDefaults.temperatureNotation == .fahrenheit
        let min = isFahrenheit ? temperatureMin : temperatureMin.toCelcius
        let max = isFahrenheit ? temperatureMax : temperatureMax.toCelcius
        let format = isFahrenheit ? "%.1f °F" : "%.1f °C"
        
        let minStr = String(format: format, min)
        let maxStr = String(format: format, max)
        return "\(minStr) - \(maxStr)"
    }
    
    public var windSpeedLabelText: String {
        let isImperial = UserDefaults.unitsNotation == .imperial
        let speed = isImperial ? windSpeed : windSpeed.toKPH
        let format = isImperial ? "%.f MPH" : "%.f KPH"
        return String(format: format, speed)
    }
}

