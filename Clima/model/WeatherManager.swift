//
//  WeatherManager.swift
//  Clima
//
//  Created by MacBook on 12/13/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7504a0b16b6aaa46ea69ad8f3553e1bb&units=metric"
    var delegate : WeatherManagerDelegate?
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
       // print(urlString)
        self.perFormRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        self.perFormRequest(with: urlString)
    }
    func perFormRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responese, error) in
                 if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                            return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(_weatherManager: self,weather: weather)
                                
                    }
                }
            }
            task.resume()
        }
    }
//    func handle(data: Data?,response: URLResponse?,error: Error?){
//        if error != nil{
//            print(error!)
//            return
//        }
//        if let safeData = data {
//            if let weather = self.parseJSON(weatherData: safeData){
//                let weatherVC = Wea
//            }
//
//        }
//    }
    func parseJSON(weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id,cityName: name, temperature: temp)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
