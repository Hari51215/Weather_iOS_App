//  WeatherManager.swift
//  Clima
//  Created by hari-pt5664 on 21/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=cf3d8cf1956f6aff44f7be30ecabe11b&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func cityWeather (cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func currentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
         let decodedData = try decoder.decode(WeatherData.self , from: weatherData)
            let temp = decodedData.main.temp
            let name = decodedData.name
            let ID = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionId: ID, cityName: name, temperature: temp)
            return weather
        }
        catch
        {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
