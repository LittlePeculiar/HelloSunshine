//
//  LocationServices.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//


import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func tracing(currentLocation: CLLocation)
    func tracingLocationDidFail(WithError type: AlertType)
}

class LocationService: NSObject {
    
    static let shared = LocationService()

    var locationManager: CLLocationManager?
    var delegate: LocationServiceDelegate?

    override init() {
        super.init()

        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else { return }
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // Request Current Location
                locationManager.requestLocation()
            default:
                // Request Authorization
                locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        guard let delegate = self.delegate else { return }
        delegate.tracing(currentLocation: currentLocation)
        stopUpdatingLocation()
    }
    
    private func updateLocationDidFail(WithError type: AlertType) {
        guard let delegate = self.delegate else { return }
        delegate.tracingLocationDidFail(WithError: AlertType.failedToRequestLocation)
        stopUpdatingLocation()
    }

}

extension LocationService: CLLocationManagerDelegate {
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            updateLocationDidFail(WithError: AlertType.notAuthorizedToRequestLocation)
        default:
            let location = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
            updateLocation(currentLocation: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFail(WithError: AlertType.failedToRequestLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateLocation(currentLocation: location)
    }
    
}
