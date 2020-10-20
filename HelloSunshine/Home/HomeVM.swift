//
//  HomeVM.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import Foundation
import CoreLocation


protocol HomeVMContract {
    
    var isLoading: Bool { get }
    var weatherData: WeatherData { get }
    var title: String { get }
    
    func didChangeLocationClosure(callback: @escaping () -> Void)
    func didFailLocationClosure(callback: @escaping (AlertType) -> Void)
}

class HomeVM: HomeVMContract {
    
    // MARK:  Public
    
    public var isLoading: Bool = false
    public var title: String {
        return "Hello Sunshine"
    }
    public var weatherData: WeatherData = WeatherData() {
        didSet {
            homeWeatherDataDidChange?()
        }
    }
    
    // MARK: Private
    
    private var homeWeatherDataDidChange: (() -> Void)?
    private var weatherDataDidFail: ((AlertType) -> Void)?
    private var api: APIContract = API()
    private let locationService = LocationService.shared
    private var currentLocation: CLLocation? = nil {
        didSet {
            fetchWeatherData()
        }
    }
        
    // MARK: Public Methods
        
    func didChangeLocationClosure(callback: @escaping () -> Void) {
        homeWeatherDataDidChange = callback
    }
    
    func didFailLocationClosure(callback: @escaping (AlertType) -> Void) {
        weatherDataDidFail = callback
    }
    
    
    // MARK: Private Methods
    
    private func fetchWeatherData() {
        guard let location = currentLocation else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Fetch Weather Data for Location
        isLoading = true
        api.weatherDataForLocation(latitude: latitude, longitude: longitude) { [weak self] (result) in
            switch result {
            case .success(let weatherData):
                
                self?.weatherData = weatherData
                self?.isLoading = false
                
            case .failure:
                print("An error occured while fetching .")
                self?.isLoading = false
            }
        }
    }
    
    // MARK: Init
       
    init() {
        locationService.delegate = self
        locationService.startUpdatingLocation()
    }
}

extension HomeVM: LocationServiceDelegate {
    func tracing(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
    }
    func tracingLocationDidFail(WithError type: AlertType) {
        weatherDataDidFail?(type)
    }
}




