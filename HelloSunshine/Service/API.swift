//
//  API.swift
//  HelloSunshine
//
//  Created by Gina Mullins on 10/6/20.
//

import UIKit

enum FetchError: Error {
    case responseFailure
    case noData
    case invalidResponseCode
    case serializationError
}

protocol APIContract {
    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, FetchError>) -> ())
}

class API: APIContract {
    
    typealias WeatherDataResult = (Result<WeatherData, FetchError>) -> ()
    let session = URLSession.shared
    
    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataResult) {
        // Create URL
        let url = WeatherServiceRequest(latitude: latitude, longitude: longitude).url
        
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
            }
        }.resume()
    }
    
    // MARK: - Helper Methods

    private func didFetchWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: WeatherDataResult) {
        
        guard error == nil else {
            completion(.failure(.responseFailure))
            return
        }
        guard let postData = data else {
            completion(.failure(.noData))
            return
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completion(.failure(.invalidResponseCode))
            return
        }
        guard let weatherData = try? JSONDecoder().decode(WeatherData.self, from: postData) else {
            completion(.failure(.serializationError))
            return
        }
        completion(.success(weatherData))
    }
}
