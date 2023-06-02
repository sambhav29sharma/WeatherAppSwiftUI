//
//  ModelUtility.swift
//  WeatherApp
//
//  Created by Sharma, Sambhav (Contractor) on 23/05/23.
//

import Foundation

struct Forecast: Codable {
    var weather : [WeatherInfo]
    var main : MainInfo
    var sys : SysInfo
    var name : String
}
struct MainInfo : Codable{
    var temp : Double
    var temp_min : Double
    var temp_max : Double
    var pressure : Int
    var humidity : Int
}
struct WeatherInfo : Codable {
    var id : Int?
    var main : String
    var description : String
    var icon : String

}
struct SysInfo : Codable{
    var country : String
}
struct ModelUtility {
  
    let apikey: String = "f806e64f3a59ae0b12aaaf377cecec68"
    let baseurl: String = "https://api.openweathermap.org/data/2.5/"
    
    static var instance = ModelUtility()
    
    private init() {
        
    }
    
    func Imageforecast(iconPic: String, call : @escaping (URL) -> Void){
        
        let imageurl = "https://openweathermap.org/img/wn/\(iconPic)@2x.png"
        
        let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let picPath = docUrl.appendingPathComponent(iconPic)
        
        if FileManager.default.fileExists(atPath: picPath.relativePath){
            call(picPath)
            return
        }
        //1.create session
        let session = URLSession.shared
        //2.create request
        if let imageURL = URL(string: imageurl){
            //3.create task and resume
            let task = session.downloadTask(with: imageURL) { url, response, error in
                //1. check error
                if error == nil && url != nil {
                    
                    //no network error
                    
                    let status = (response as! HTTPURLResponse).statusCode
                        
                        if status == 200 {
                            try! FileManager.default.moveItem(at: url!, to: picPath)
                            call(picPath)
                            
                            
                        }
                    
                }
                else {
                    print("Network Problem")
                }
            }
            task.resume()
        }
    }
   
    func weatherforecast(lat : Double,lon : Double, handler: @escaping (Forecast) -> Void) {
        
        let forecastUrl = "\(baseurl)weather?lat=\(lat)&lon=\(lon)&appid=\(apikey)&units=metric"
        
        //2.create request
        if let weatherUrl = URL(string: forecastUrl){
            
            //1. create session
            let session = URLSession.shared
 
            //3.create a task and resume
            
           let task = session.dataTask(with: weatherUrl) { weatherData, resp, error in
                
                //1. check error
               if error == nil && weatherData != nil {
                   
                   // no network error
                   
                   //parse JSON
                   let decoder = JSONDecoder()
                   
                   do{
                       let weatherfeed = try decoder.decode(Forecast.self, from: weatherData!)
                      // print("\(weatherfeed)")
                       handler(weatherfeed)
//                       print("Country Code : \(weatherfeed.sys.country)")
//                       print("Description: \(weatherfeed.weather[0].description)")
//                       print("Name : \(weatherfeed.self.name)")
//                       print("Temperature : \(weatherfeed.main.temp)")
//                       print("Min Temp : \(weatherfeed.main.temp_min)")
//                       print("Max Temp : \(weatherfeed.main.temp_max)")
//                       print("Pressure : \(weatherfeed.main.pressure)")
//                       print("Humidity : \(weatherfeed.main.humidity)")
//                       print("Icon: \(weatherfeed.weather[0].icon)")
//                       
                   }
                   catch{
                       //print("Decoding error :\(error.localizedDescription)")
                       print(String(describing: error))
                   }
                   
                   //2.HTTP Status code
                   if let statusCode = (resp as? HTTPURLResponse)?.statusCode {
                       switch statusCode{
                       case 200...299:
                           //3. if Success, parse the response
                           print("Success \(statusCode)")
                       default:
                           print("Failed \(statusCode)", error?.localizedDescription ?? "")
                       }
                 }
            }
               else {
                   print("Network problem")
               }
           }
            task.resume() // request fired
        }
        else {
            print("Invalid URL")
        }
     }
 }
