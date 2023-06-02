//
//  WeatherDetail.swift
//  WeatherAppSUI
//
//  Created by Sharma, Sambhav (Contractor) on 29/05/23.
//

import SwiftUI

struct WeatherDetail: View {
    //reference of viewmodel that is strong reference
    var vModeL = ViewModelUtility()
    var options = ["°C", "°F","K"]
    @State private var selectedOptions  = "°C"
    var lat: Double = 0
    var long : Double = 0
    @State var uniT : String = "metric"
    
    @State var imageResult : String?
    @State var forecastResult : Forecast?
    
    var body: some View {
        
        ZStack() {
            Color.mint.ignoresSafeArea(.all)
            
             VStack(alignment: .leading, spacing: 10) {
                 Text("\(forecastResult?.name ?? "")")
                    .bold()
                    .font(.title)
              
                 HStack(spacing: 90){
                     
                     Text("Today,\(Date().formatted(.dateTime.month().day().hour().minute()))")
                         .fontWeight(.light)
                     
                     Picker(selection : $selectedOptions, label: Text("Units")) {
                         ForEach(options, id: \.self){
                             Text($0).tag($0)
                         
                         }
                      
                     }
                     
                     .pickerStyle(.segmented)
                     .foregroundStyle(.white)
                     .frame(width : 100)
                     .onChange(of: selectedOptions) { newValue in
                         switch newValue {
                         case "°F":
                            self.uniT = "imperial"
                             print("I AM FAHRENHEIT")
                            
                         case "K":
                            self.uniT = "default"
                             print("I AM KELVIN")
                             
                         default:
                             self.uniT = "metric"
                             print("I AM CELSIUS")
                         }
                         
                         vModeL.getWeatherData(lat: lat, lon: long, unitss: uniT) { newForecast in
                             self.forecastResult = newForecast
                         }
                     }
                 
                 }
                 Spacer()
                 
                 VStack(alignment: .center){
                     
                     Text("Today: \(forecastResult?.main.temp.roundDouble() ?? "")\(selectedOptions)")
                         .font(.system(size: 25))
                         .frame(maxWidth: .infinity)
                         .fontWeight(.bold)
                         .padding()
                     
                         VStack(spacing: 2){
                             if let url = URL(string: "\(imageResult ?? "")") {
                             
                                 let img = UIImage(data: try! Data(contentsOf: url))!
                                 Image(uiImage: img)
                                     .resizable()
                                     .frame(width: 200, height: 200)
                                    .padding()
                             }
//                             AsyncImage(url: URL(string: "\(imageResult ?? "")"))
//
//                                 .frame(width: 250, height: 200)
//                                 .padding()
                             
                          
                             Text("\(forecastResult?.weather[0].description ?? "")")
                                 
                         }
                         //Text(\(forecastResult?.main.temp ?? 0)°C ?? 0, format: .number)
                         
                    }
                     .frame(alignment: .center)
                     .padding()
                 
                 ZStack(alignment: .bottom){
                     Spacer()
                     VStack(alignment: .leading){
                         
                         HStack{
                             Image(systemName: "thermometer.sun")
                                 .resizable()
                                 .frame(width: 45, height: 45)
                                 .font(.title2)
                                 .padding()
                                 
                             
                             VStack(alignment: .leading, spacing: 5) {
                                 Text("Min Temp")
                                     .font(.title3)
                                 
                                 Text("\(forecastResult?.main.temp_min.roundDouble() ?? "")\(selectedOptions)")
                                     .font(.title2)
                                 
                             }
                             
                         }
                         
                         HStack{
                             Image(systemName: "thermometer.sun.fill")
                                 .resizable()
                                 .frame(width: 45, height: 45)
                                 .font(.title2)
                                 .padding()
                             
                             VStack(alignment: .leading, spacing: 5) {
                                 Text("Max Temp")
                                     .font(.title3)
                                 
                                 Text("\(forecastResult?.main.temp_max.roundDouble() ?? "")\(selectedOptions)")
                                     .font(.title2)
                                 
                             }
                             
                         }
                         HStack{
                             Image(systemName: "humidity.fill")
                                 .resizable()
                                 .frame(width: 40, height: 40)
                                 .font(.title2)
                                 .padding()
                             
                             VStack(alignment: .leading, spacing: 5) {
                                 Text("Humidity")
                                     .font(.title3)
                                 
                                 Text("\(forecastResult?.main.humidity ?? 0)")
                                     .font(.title2)
                                 
                                 
                             }
                             
                         }
                         HStack{
                             Image(systemName: "water.waves")
                                 .resizable()
                                 .frame(width: 42, height: 42)
                                 .font(.title2)
                                 .padding()
                             
                             VStack(alignment: .leading, spacing: 5) {
                                 Text("Pressure")
                                     .font(.title3)
                                 
                                 Text("\(forecastResult?.main.pressure ?? 0)")
                                     .font(.title2)
                                 
                             }
                             
                         }
                     }
                     
                 }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
           
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear(){
            vModeL.getWeatherData(lat: lat, lon: long, unitss: uniT) { weatherResult in
                
                self.forecastResult = weatherResult
                let iconName = forecastResult?.weather[0].icon
                vModeL.getImageVM(iconn: iconName!) { url in
                        print(url)
                 self.imageResult = url.absoluteString
                    }
   
            }
   
        }

    }
    
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail()
    }
}
//this extension is for creation of integer values from existing double values.
extension Double{
    func roundDouble () -> String {
        //this format is specific for conversion.
        return String(format: "%.0f", self)
    }
}
