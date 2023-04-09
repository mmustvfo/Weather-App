//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Mustafo on 09/04/23.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: NSObject {
        
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var currentWeather: Weather?
    @Published var forecastWeather: [Forecastday] = []
    
    
    private var cancellables = Set<AnyCancellable>()
    
    private let apiManager: APIManager
    
    var forecastDays = 3 {
        didSet {
            guard let currentLocation else { return }
            apiManager.fetchWeatherData(for: currentLocation, forecastDays: forecastDays, completion: weatherDataCompletion)
        }
    }

    
    init(apiManager: APIManager = WeatherAPIManager()) {
        self.apiManager = apiManager
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        addBindings()
    }
    
    private func addBindings() {
        
        $currentLocation
            .sink { [weak self] location in
                guard let location, let self else { return }
                self.apiManager.fetchWeatherData(for: location,forecastDays: self.forecastDays, completion: self.weatherDataCompletion)
            }
            .store(in: &cancellables)
        
    }
    
    private func weatherDataCompletion(_ result: Result<Weather, Error>) {
        switch result {
        case .success(let weatherData):
            currentWeather = weatherData
            forecastWeather = weatherData.forecast.forecastday
        case .failure(let error):
            print("Failure: \(error.localizedDescription)")
        }
    }
    
}

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            print("Recieved location")
            currentLocation = userLocation
        } else {
            fatalError("No location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager did fail with error: \(error.localizedDescription)")
    }
    
}


