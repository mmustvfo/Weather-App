//
//  WeatherAPIManager.swift
//  Weather App
//
//  Created by Mustafo on 09/04/23.
//

import Foundation
import CoreLocation
import Combine

//https://api.weatherapi.com/v1/forecast.json?key=62d9349169c14d6aa78173851230904&q=Tashkent&days=3&aqi=no&alerts=no

class WeatherAPIManager: APIManager {
    
    private let apiKey = "62d9349169c14d6aa78173851230904"
    private let city = "Tashkent"
    
    func fetchWeatherData(for location: CLLocation,forecastDays: Int ,completion: @escaping(Result<Weather, Error>)-> Void) {
        guard let requestURL = buildURL(city: city, forecastDays: forecastDays) else {
            return
        }
        print("Request url: \(requestURL.absoluteString)")
        URLSession.shared.dataTask(with: URLRequest(url: requestURL)) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let weatherData = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weatherData))
            } catch {
                print("Erro while trying to parse data: \(error)")
                completion(.failure(error))
            }
        }
        .resume()
    }
    

    
    private func buildURL(city: String, forecastDays: Int)-> URL? {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=62d9349169c14d6aa78173851230904&q=\(city)&days=\(forecastDays)&aqi=no&alerts=no"
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}
