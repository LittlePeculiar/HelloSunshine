//
//  Enums.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//


enum TimeNotation: Int {
    case twelveHour
    case twentyFourHour
}

enum UnitsNotation: Int {
    case imperial
    case metric
}

enum TemperatureNotation: Int {
    case fahrenheit
    case celsius
}

enum LocationTableSection: Int, CaseIterable {

    case current
    case favorite
    case recent

    // MARK: - Properties

    var title: String {
        switch self {
        case .current: return "Current Location"
        case .favorite: return "Favorite Locations"
        case .recent: return "Recent Locations"
        }
    }

}

enum AlertType {
    
    case notAuthorizedToRequestLocation
    case failedToRequestLocation
    case noWeatherDataAvailable
    
    func title() -> String {
        return "Unable to Fetch Weather Data for Your Location"
    }
    
    func message() -> String {
        switch self {
        case .notAuthorizedToRequestLocation:
            return AlertTypeMessage().notAuthorizedToRequestLocationMessage
        case .failedToRequestLocation:
            return AlertTypeMessage().failedToRequestLocationMessage
        case .noWeatherDataAvailable:
            return AlertTypeMessage().noWeatherDataAvailableMessage
        }
    }
}

struct AlertTypeMessage {
    let notAuthorizedToRequestLocationMessage = "Cloudy is not authorized to access your current location. You can grant access in the Settings."
    let failedToRequestLocationMessage = "Cloudy is not able to fetch your current location due to a technical issue."
    let noWeatherDataAvailableMessage = "No weather data is available at this time."
}
