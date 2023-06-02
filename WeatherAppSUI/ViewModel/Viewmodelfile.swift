//
//  Viewmodelfile.swift
//  WeatherAppSUI
//
//  Created by Sharma, Sambhav (Contractor) on 02/06/23.
//

import Foundation

struct ViewModelUtility {
    
    //reference to model
    private var weathermodel = ModelUtility.instance
    
    func getImageVM(iconn: String, callback: @escaping (URL) -> Void) {
        
        weathermodel.Imageforecast(iconPic: iconn, call: callback)
    }
    
    func getWeatherData(lat : Double, lon : Double, handler : @escaping (Forecast) -> Void) {
        weathermodel.weatherforecast(lat: lat, lon: lon, handler: handler)
    }
    
}
