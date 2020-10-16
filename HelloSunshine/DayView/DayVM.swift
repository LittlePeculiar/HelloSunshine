//
//  DayVM.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//


import UIKit
import CoreLocation

protocol DayVMContract {
    var isLoading: Bool { get }
    var weatherData: WeatherData { get set }
    var dateLabelText: String { get }
    var timeLabelText: String { get }
    var temperatureLabelText: String { get }
    var windSpeedLabelText: String { get }
    var summaryLabelText: String { get }
    
    func didChangeDataClosure(callback: @escaping () -> Void)
    func foundCityFromLocationClosure(callback: @escaping (String) -> Void)
}

class DayVM: DayVMContract {

    // MARK: Private Properties

    private var weatherDataDidChange: (() -> Void)?
    private var foundCity: ((String) -> Void)?
    private let dateFormatter = DateFormatter()

    // MARK: Public Properties

    public var isLoading: Bool = false
    public var weatherData: WeatherData = WeatherData() {
        didSet {
            weatherDataDidChange?()
            fetchCity()
        }
    }

    // MARK: Public computed properties

    public var dateLabelText: String {
        dateFormatter.dateFormat = "EEE, MMMM d"
        return dateFormatter.string(from: weatherData.time)
    }

    public var timeLabelText: String {
        let isTwelveHour = UserDefaults.timeNotation == .twelveHour
        let format = isTwelveHour ? "hh:mm a" : "HH:mm"
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: weatherData.time)
    }

    public var temperatureLabelText: String {
        let isFahrenheit = UserDefaults.temperatureNotation == .fahrenheit
        let temperature = isFahrenheit ? weatherData.temperature : weatherData.temperature.toCelcius
        let format = isFahrenheit ? "%.1f °F" : "%.1f °C"
        return String(format: format, temperature)
    }
    public var windSpeedLabelText: String {
        let isImperial = UserDefaults.unitsNotation == .imperial
        let windSpeed = isImperial ? weatherData.windSpeed : weatherData.windSpeed.toKPH
        let format = isImperial ? "%.f MPH" : "%.f KPH"
        return String(format: format, windSpeed)
    }

    public var summaryLabelText: String {
        weatherData.summary
    }
    
    // MARK: Public Methods
        
    func didChangeDataClosure(callback: @escaping () -> Void) {
        weatherDataDidChange = callback
    }
    
    func foundCityFromLocationClosure(callback: @escaping (String) -> Void) {
        foundCity = callback
    }
    
    // MARK: Private Methods
    private func fetchCity() {
        let location = CLLocation(latitude: weatherData.latitude, longitude: weatherData.longitude)
        location.fetchCityAndCountry { [weak self] city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            let found = city + ", " + country
            self?.foundCity?(found)
        }
    }
    
    
    // MARK: Init
    init(data: WeatherData) {
        self.weatherData = data
    }
}

