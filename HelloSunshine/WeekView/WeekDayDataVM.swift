//
//  WeekDayDataVM.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/19/20.
//

import UIKit

protocol WeekDayDataVMContract {
    var dayLabelText: String { get }
    var dateLabelText: String { get }
    var temperatureLabelText: String { get }
    var windSpeedLabelText: String { get }
    var weatherIconName: String { get }
}

class WeekDayDataVM: WeekDayDataVMContract {

    private var weatherDayData: WeatherDayData = WeatherDayData()

    init(with data: WeatherDayData) {
        self.weatherDayData = data
    }
}

extension WeekDayDataVM {
    // MARK: computed props

    public var dayLabelText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: weatherDayData.time)
    }

    public var dateLabelText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: weatherDayData.time)
    }

    public var temperatureLabelText: String {
        let temperatureMin = weatherDayData.temperatureMin
        let temperatureMax = weatherDayData.temperatureMax

        let isFahrenheit = UserDefaults.temperatureNotation == .fahrenheit
        let min = isFahrenheit ? temperatureMin : temperatureMin.toCelcius
        let max = isFahrenheit ? temperatureMax : temperatureMax.toCelcius
        let format = isFahrenheit ? "%.1f °F" : "%.1f °C"

        let minStr = String(format: format, min)
        let maxStr = String(format: format, max)
        return "\(minStr) - \(maxStr)"
    }

    public var windSpeedLabelText: String {
        let windSpeed = weatherDayData.windSpeed

        let isImperial = UserDefaults.unitsNotation == .imperial
        let speed = isImperial ? windSpeed : windSpeed.toKPH
        let format = isImperial ? "%.f MPH" : "%.f KPH"
        return String(format: format, speed)
    }

    public var weatherIconName: String {
        weatherDayData.icon
    }
}
