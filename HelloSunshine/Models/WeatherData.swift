//
//  WeatherData.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import Foundation

struct WeatherData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case latitude
        case longitude
        case daily
        case currently
    }
    
    enum CurrentlyCodingKeys: String, CodingKey {
        
        case time
        case icon
        case summary
        case windSpeed
        case temperature
    }
    
    enum DailyCodingKeys: String, CodingKey {
        
        case data
    }
    
    // MARK: - Properties
    
    let time: Date
    let icon: String
    let summary: String
    let windSpeed: Double
    let temperature: Double
    
    let latitude: Double
    let longitude: Double
    
    let dailyData: [WeatherDayData]
    
    // MARK: Public Properties
    
    public var dateLabelText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMMM d"
        return dateFormatter.string(from: self.time)
    }
    
    public var timeLabelText: String {
        let timeFormatter = DateFormatter()
        
        if UserDefaults.timeNotation == .twelveHour {
            timeFormatter.dateFormat = "hh:mm a"
        } else {
            timeFormatter.dateFormat = "HH:mm"
        }
        return timeFormatter.string(from: self.time)
    }
    
    public var temperatureLabelText: String {
        var temperature = self.temperature
        
        if UserDefaults.temperatureNotation != .fahrenheit {
            temperature = temperature.toCelcius
            return String(format: "%.1f °C", temperature)
        } else {
            return String(format: "%.1f °F", temperature)
        }
    }
    public var windSpeedLabelText: String {
        var windSpeed = self.windSpeed
        
        if UserDefaults.unitsNotation != .imperial {
            windSpeed = windSpeed.toKPH
            return String(format: "%.f KPH", windSpeed)
        } else {
            return String(format: "%.f MPH", windSpeed)
        }
    }

}

extension WeatherData {
    
    // MARK: - Initialization

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Latitude and Longitude
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        
        // Nested Container: Daily
        let daily = try container.nestedContainer(keyedBy: DailyCodingKeys.self, forKey: .daily)
        self.dailyData = try daily.decode([WeatherDayData].self, forKey: .data)

        // Nested Container: Currently
        let currently = try container.nestedContainer(keyedBy: CurrentlyCodingKeys.self, forKey: .currently)
        self.time = try currently.decode(Date.self, forKey: .time)
        self.windSpeed = try currently.decode(Double.self, forKey: .windSpeed)
        self.temperature = try currently.decode(Double.self, forKey: .temperature)
        self.icon = try currently.decode(String.self, forKey: .icon)
        self.summary = try currently.decode(String.self, forKey: .summary)
    }
    
    init() {
        time = Date()
        icon = ""
        summary = ""
        windSpeed = 0.0
        temperature = 0.0
        latitude = 0.0
        longitude = 0.0
        dailyData = []
    }
}

