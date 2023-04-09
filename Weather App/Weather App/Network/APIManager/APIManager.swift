//
//  APIManager.swift
//  Weather App
//
//  Created by Mustafo on 09/04/23.
//

import Foundation
import CoreLocation

protocol APIManager {
    
    func fetchWeatherData(for location: CLLocation,forecastDays: Int ,completion: @escaping(Result<Weather, Error>)-> Void) 
    
}
