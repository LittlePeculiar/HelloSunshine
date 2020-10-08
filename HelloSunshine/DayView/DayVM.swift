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
    
    func didChangeDataClosure(callback: @escaping () -> Void)
    func foundCityFromLocationClosure(callback: @escaping (String) -> Void)
}

class DayVM: DayVMContract {
    
    public var isLoading: Bool = false
    public var weatherData: WeatherData = WeatherData() {
        didSet {
            weatherDataDidChange?()
            fetchCity()
        }
    }
    
    // MARK: Private
    
    private var weatherDataDidChange: (() -> Void)?
    private var foundCity: ((String) -> Void)?
    
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

