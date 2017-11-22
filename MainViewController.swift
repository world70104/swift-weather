//
//  MainViewController.swift
//  Weather
//
//  Created by POLARIS on 11/04/17.
//  Copyright © 2017 POLARIS. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UITableViewController, UITextFieldDelegate {
    
    private let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "aeef7398d32b9256190f748eee8825f4"
    
    var coord_lon = Double()
    var coord_lat = Double()
    var base = String()
    var main_temp = Double()
    var main_pressure = Double()
    var main_humidity = Double()
    var main_temp_min = Double()
    var main_temp_max = Double()
    var wind_speed = Double()
    var wind_deg = Double()
    var clouds_all = Double()
    var dt = Double()
    var sys_message = Double()
    var sys_country = String()
    var sys_sunrise = Double()
    var sys_sunset = Double()
    var id = Double()
    var name = String()
    var cod = Int()
    var weather_id = Int()
    var weather_main = String()
    var weather_description = String()
    var weather_icon = String()

    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    @IBOutlet var countryTextField: SearchTextField!
    
    @IBAction func cityTouch(_ sender: Any) {
        countryTextField.startVisibleWithoutInteraction = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backGroundImage: UIImageView = UIImageView(image: UIImage(named: "background.jpeg")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0))
        self.tableView.backgroundView = backGroundImage
        
        tableView.tableFooterView = UIView()
        
        // Configure a simple search text field
        configureSimpleSearchTextField()
        
        countryTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Configure a simple search text view
    fileprivate func configureSimpleSearchTextField() {
        // Start visible even without user's interaction as soon as created - Default: false
        countryTextField.startVisibleWithoutInteraction = false
        
        // Set data source
        let cities: [String] = [""]
        countryTextField.filterStrings(cities)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.setLoadingScreen()
        self.getWeather(city: countryTextField.text!)
        return true
    }
    
    ////////////////////////////////////////////////////////
    // Data Sources
    
    func getWeather(city: String) {
        var _city = ""
        for i in city
        {
            if i == " "  {
                _city += "%20"
            }
            else{
                _city += "\(i)"
            }
        }
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        let url_str = "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(_city)"
        let weatherRequestURL = NSURL( string: url_str )!
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL as URL) {
            (data, response, error) -> Void in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            } else {
                // Case 2: Success
                // We got a response from the server!
                print("Raw data:\n\(data!)\n")
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                print("Human-readable data:\n\(dataString!)")
                self.dataTodic( data: data!)
                DispatchQueue.main.async{
                    // display
                    self.process()
                }
            }
        }
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
    ///////////////////////////////////////////////////////////////////////////
    //       Parsing JSON Data to Dictionary
    //
    //  created: 10/14/2017
    //   inp: JSON Data
    //   out: if sucessful, JSON dictionary
    //          other, empty dictionary
    ///////////////////////////////////////////////////////////////////////////
    func dataTodic( data: Data )  {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            let message = jsonData[ "message" ]// as! String
            if message != nil {
                let alert = UIAlertController(title: nil, message: "City not found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: false)
            } else {
                
                // coord
                let coord = jsonData[ "coord" ] as! NSDictionary
                coord_lon =  coord[ "lon" ] as! Double
                coord_lat =  coord[ "lat" ] as! Double
                
                // weather
                let weather1 = jsonData[ "weather" ] as! NSArray
                let weather = weather1[0] as! NSDictionary
                weather_id =  weather[ "id" ] as! Int
                weather_main =  weather[ "main" ] as! String
                weather_description =  weather[ "description" ] as! String
                weather_icon =  weather[ "icon" ] as! String
                
                // base
                base = jsonData[ "base" ] as! String
                
                // main
                let main = jsonData[ "main" ] as! NSDictionary
                main_temp =  main[ "temp" ] as! Double
                main_pressure =  main[ "pressure" ] as! Double
                main_humidity =  main[ "humidity" ] as! Double
                main_temp_min =  main[ "temp_min" ] as! Double
                main_temp_max =  main[ "temp_max" ] as! Double
                
                // wind
                let wind = jsonData[ "wind" ] as! NSDictionary
                wind_speed =  wind[ "speed" ] as! Double
                
                var deg : Double?
                    deg = wind[ "deg" ] as? Double
                if deg !=  nil  {
                    wind_deg = wind[ "deg" ] as! Double
                }
                else {
                    wind_deg = -1
                }
                
                // clouds
                let clouds = jsonData[ "clouds" ] as! NSDictionary
                clouds_all =  clouds[ "all" ] as! Double
                
                // dt
                dt = jsonData[ "dt" ] as! Double
                
                // sys
                let sys = jsonData[ "sys" ] as! NSDictionary
                sys_message =  sys[ "message" ] as! Double
                sys_country =  sys[ "country" ] as! String
                sys_sunrise =  sys[ "sunrise" ] as! Double
                sys_sunset =  sys[ "sunset" ] as! Double
                
                // id
                id = jsonData[ "id" ] as! Double
                
                // name
                name = jsonData[ "name" ] as! String
                
                // code
                cod = jsonData[ "cod" ] as! Int
                
            }
            
        } catch {
        }
    }
    
    func process() {
        if let wvc = self.storyboard?.instantiateViewController(withIdentifier: "weather") as?  WeatherViewController {
            
            wvc.paramCity = self.name
            wvc.paramCountry = self.sys_country
            wvc.paramWeather = self.weather_main
            wvc.paramDate = NSDate(timeIntervalSince1970: self.dt) as Date
            wvc.paramWeatherIcon = self.weather_icon
            wvc.paramTemp_c = String(format:"%.1f", self.main_temp - 273.5)
            wvc.paramTemp_f = String(format:"%.1f", self.main_temp * 9 / 5 - 459.67)
            wvc.paramTemp_max_c = String(format:"%.1f", self.main_temp_max - 273.5)
            wvc.paramTemp_max_f = String(format:"%.1f", self.main_temp_max * 9 / 5 - 459.67)
            wvc.paramTemp_min_c = String(format:"%.1f", self.main_temp_min - 273.5)
            wvc.paramTemp_min_f = String(format:"%.1f", self.main_temp_min * 9 / 5 - 459.67)
            wvc.paramWindSpeed = String(format:"%.1f", self.wind_speed)
            
            if self.wind_deg != -1 {
                let val = Int((self.wind_deg / 22.5) + 0.5)
                var arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
                let index = val % 16
                wvc.paramWindDeg = arr[index]
            }
            else {
                wvc.paramWindDeg = " "
            }
            wvc.paramCloud = String(format:"%.f", self.clouds_all)
            wvc.paramPress = String(format:"%.2f", self.main_pressure)
            wvc.paramHumidity = String(format:"%.f", self.main_humidity)
            wvc.paramSunRise = NSDate(timeIntervalSince1970: self.sys_sunrise) as Date
            wvc.paramSunSet = NSDate(timeIntervalSince1970: self.sys_sunset) as Date
            wvc.paramCoord_lat = String(format:"%.2f", self.coord_lat)
            wvc.paramCoord_lon = String(format:"%.2f", self.coord_lon)
            self.navigationController?.pushViewController(wvc, animated: true)
            self.removeLoadingScreen()
        }
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 30
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds spinner to the view
        loadingView.addSubview(spinner)
        
        tableView.addSubview(loadingView)
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
    }
}
