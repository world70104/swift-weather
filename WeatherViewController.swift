//
//  WeatherViewController.swift
//  Weather
//
//  Created by POLARIS on 11/04/17.
//  Copyright © 2017 POLARIS. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var paramCity = String()
    var paramCountry = String()
    var paramWeather = String()
    var paramDate = Date()
    var paramWeatherIcon = String()
    var paramTemp_c = String()
    var paramTemp_f = String()
    var paramTemp_max_c = String()
    var paramTemp_max_f = String()
    var paramTemp_min_c = String()
    var paramTemp_min_f = String()
    var paramWindSpeed = String()
    var paramWindDeg = String()
    var paramCloud = String()
    var paramPress = String()
    var paramHumidity = String()
    var paramSunRise = Date()
    var paramSunSet = Date()
    var paramCoord_lat = String()
    var paramCoord_lon = String()
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var timeImage: UIImageView!
    @IBOutlet var city: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var temp: UILabel!
    @IBOutlet var temp_max: UILabel!
    @IBOutlet var temp_min: UILabel!
    @IBOutlet var wind: UILabel!
    @IBOutlet var cloud: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var sunRise: UILabel!
    @IBOutlet var sunSet: UILabel!
    @IBOutlet var coord: UILabel!
    @IBOutlet var getTemp_max: UILabel!
    @IBOutlet var getTemp_min: UILabel!
    @IBOutlet var getWind: UILabel!
    @IBOutlet var getCloud: UILabel!
    @IBOutlet var getPressure: UILabel!
    @IBOutlet var getHumidity: UILabel!
    @IBOutlet var getSunrise: UILabel!
    @IBOutlet var getSunset: UILabel!
    @IBOutlet var getCoord: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImage.image = UIImage(named: "sky.jpeg")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let setTime = timeFormatter.string(from: paramDate)
        
        if setTime >= "05:00" && setTime < "08:00" {
            self.timeImage.image = UIImage(named: "weather-sunrise.jpeg")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            self.city.textColor = UIColor.white
            self.weather.textColor = UIColor.white
            self.date.textColor = UIColor.white
        } else if setTime >= "08:00" && setTime < "17:00"{
            self.timeImage.image = UIImage(named: "weather-sunshine.jpeg")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            self.city.textColor = UIColor.black
            self.weather.textColor = UIColor.black
            self.date.textColor = UIColor.black
        } else if setTime >= "17:00" && setTime < "19:00"{
            self.timeImage.image = UIImage(named: "weather-sundown.jpeg")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            self.city.textColor = UIColor.white
            self.weather.textColor = UIColor.white
            self.date.textColor = UIColor.white
        } else if setTime >= "19:00" && setTime <= "23:59"{
            self.timeImage.image = UIImage(named: "weather-night.jpeg")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            self.city.textColor = UIColor.white
            self.weather.textColor = UIColor.white
            self.date.textColor = UIColor.white
        } else if setTime >= "00:00" && setTime < "05:00"{
            self.timeImage.image = UIImage(named: "weather-night.jpeg")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            self.city.textColor = UIColor.white
            self.weather.textColor = UIColor.white
            self.date.textColor = UIColor.white
        }
        
        self.city.text = "\(paramCity), \(paramCountry)"
        self.weather.text = paramWeather
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.date.text = dateFormatter.string(from: paramDate)
        
        if paramWeatherIcon == "01d" {
            self.weatherIcon.image = UIImage(named: "01d.png")
        } else if paramWeatherIcon == "02d" {
            self.weatherIcon.image = UIImage(named: "02d.png")
        } else if paramWeatherIcon == "03d" {
            self.weatherIcon.image = UIImage(named: "03d.png")
        } else if paramWeatherIcon == "04d" {
            self.weatherIcon.image = UIImage(named: "04d.png")
        } else if paramWeatherIcon == "09d" {
            self.weatherIcon.image = UIImage(named: "09d.png")
        } else if paramWeatherIcon == "10d" {
            self.weatherIcon.image = UIImage(named: "10d.png")
        } else if paramWeatherIcon == "11d" {
            self.weatherIcon.image = UIImage(named: "11d.png")
        } else if paramWeatherIcon == "13d" {
            self.weatherIcon.image = UIImage(named: "13d.png")
        } else if paramWeatherIcon == "50d" {
            self.weatherIcon.image = UIImage(named: "50d.png")
        } else if paramWeatherIcon == "01n" {
            self.weatherIcon.image = UIImage(named: "01n.png")
        } else if paramWeatherIcon == "02n" {
            self.weatherIcon.image = UIImage(named: "02n.png")
        } else if paramWeatherIcon == "03n" {
            self.weatherIcon.image = UIImage(named: "03n.png")
        } else if paramWeatherIcon == "04n" {
            self.weatherIcon.image = UIImage(named: "04n.png")
        } else if paramWeatherIcon == "09n" {
            self.weatherIcon.image = UIImage(named: "09n.png")
        } else if paramWeatherIcon == "10n" {
            self.weatherIcon.image = UIImage(named: "10n.png")
        } else if paramWeatherIcon == "11n" {
            self.weatherIcon.image = UIImage(named: "11n.png")
        } else if paramWeatherIcon == "13n" {
            self.weatherIcon.image = UIImage(named: "13n.png")
        } else if paramWeatherIcon == "50n" {
            self.weatherIcon.image = UIImage(named: "50n.png")
        }
        
        self.temp.text = "\(paramTemp_c)℃/\(paramTemp_f)℉"
        self.getTemp_max.text = "\(paramTemp_max_c)℃/\(paramTemp_max_f)℉"
        self.getTemp_min.text = "\(paramTemp_min_c)℃/\(paramTemp_min_f)℉"
        self.getWind.text = "\(paramWindSpeed) m/s, \(paramWindDeg)"
        self.getCloud.text = "\(paramCloud) %"
        self.getPressure.text = "\(paramPress) hpa"
        self.getHumidity.text = "\(paramHumidity) %"
        
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let sunrisetime = timeFormatter.string(from: paramSunRise)
        let sunsettime = timeFormatter.string(from: paramSunSet)
        
        self.getSunrise.text = "\(sunrisetime) UTC"
        self.getSunset.text = "\(sunsettime) UTC"
        self.getCoord.text = "[\(paramCoord_lat), \(paramCoord_lon)]"
    }
}
