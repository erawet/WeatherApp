//
//  ViewController.swift
//  Weather
//
//  Created by Don E Wettasinghe on 8/15/23.
//


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        loadLastLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadLastLocation()
    }
    
    func loadLastLocation(){
        let userDefaultsManager = UserDefaultsManager.shared
        let lastLocation = userDefaultsManager.getString(forKey: Utility.kLastlocationKey)
        let lastLat = userDefaultsManager.getDouble(forKey: Utility.kLastLatKey)
        let lastLon = userDefaultsManager.getDouble(forKey: Utility.kLastlonKey)
        
        weatherManager.fetchLastLocation(cityName: lastLocation, latitude: lastLat, longitude: lastLon)
        print("last location: \(lastLocation) and Lat::\(lastLat) & Long:: \(lastLon)")
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
           // weatherManager.fetchWeather(cityName: city)
            weatherManager.fetchWeather(searchString: city)
            UserDefaultsManager.shared.saveString(city, forKey: Utility.kLastlocationKey)
        }
        
        searchTextField.text = ""
        
    }
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            UserDefaultsManager.shared.saveDouble(lat, forKey: Utility.kLastLatKey)
            UserDefaultsManager.shared.saveDouble(lon, forKey: Utility.kLastlonKey)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
