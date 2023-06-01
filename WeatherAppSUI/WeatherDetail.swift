//
//  WeatherDetail.swift
//  WeatherAppSUI
//
//  Created by Sharma, Sambhav (Contractor) on 29/05/23.
//

import SwiftUI

struct WeatherDetail: View {
    var options = ["°C", "°F"]
    @State private var selectedOptions  = "°C"
    var lat: Double = 0
    var long : Double = 0
    
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
                     
                     Picker(selection : $selectedOptions, label: Text("")) {
                         ForEach(options, id: \.self){
                             Text($0).tag($0)
                         
                         }
                      
                     }
                     
                     .pickerStyle(.segmented)
                     .foregroundStyle(.white)
                     .frame(width : 100)
                 
                 }
                 Spacer()
                 
                 VStack(alignment: .center){
                     
                     Text("Today: \(forecastResult?.main.temp ?? 0)°C")
                         .font(.system(size: 25))
                         .frame(maxWidth: .infinity)
                         .fontWeight(.bold)
                         .padding()
                     
                         VStack(spacing: 2){
             
                             AsyncImage(url: URL(string: "\(imageResult ?? "")"))
                                 
                                 .frame(width: 250, height: 200)
                                 .padding()
                             
                          
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
                                 
                                 Text("\(forecastResult?.main.temp_min ?? 0)°C")
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
                                 
                                 Text("\(forecastResult?.main.temp_max ?? 0)°C")
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
            ModelUtility.instance.weatherforecast(lat: lat, lon: long) { weatherResult in
                
                self.forecastResult = weatherResult
                let iconName = forecastResult?.weather[0].icon
             ModelUtility.instance.Imageforecast(iconPic: iconName!) { url in
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
