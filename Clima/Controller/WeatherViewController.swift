//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
}
 //MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: Any) {
           searchTextField.endEditing(true)
           print(searchTextField.text!)
       }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          searchTextField.endEditing(true)
          return true
      }
      func textFieldDidEndEditing(_ textField: UITextField) {
          if let city = searchTextField.text {
              weatherManager.fetchWeather(cityName: city)
          }
          searchTextField.text = ""
      }
      func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
          if textField.text != ""{
              return true
          }
          else{
              textField.placeholder = "Type Something"
              return false
          }
      }
}
//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_weatherManager: WeatherManager,weather: WeatherModel){
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.temperatureString
               self.conditionImageView.image = UIImage(systemName: weather.getConditionName(conditionId: weather.conditionId))
               self.cityLabel.text = weather.cityName
           }
           
       }
       func didFailWithError(error: Error) {
           print(error)
       }
}
//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat,longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

