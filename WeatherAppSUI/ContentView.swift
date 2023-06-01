//
//  ContentView.swift
//  WeatherAppSUI
//
//  Created by Sharma, Sambhav (Contractor) on 26/05/23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State private var location : String = ""
    @FocusState private var isFocused: Bool
    @State var latt : Double = 0
    @State var longg : Double = 0
    
    var body: some View {
        
        NavigationView {
            
            VStack (spacing : 150){
               
                HStack {
                    TextField("Enter Location", text: $location)
                    
                        .focused($isFocused)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit {
                            if location.isEmpty {
                                isFocused = true
                            }
                            else {
                                search()
                            }
                        }
                    
                    NavigationLink(destination: WeatherDetail(lat: latt, long: longg), label: {
                        
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.largeTitle)
                         
                    }
                    )
                    .padding(.horizontal)
                    
                }
                Image(systemName: "cloud.sun.bolt.fill")
                    
                    .resizable()
                    .frame(width: 300, height: 400)
                    .foregroundColor(.blue)
                
                
                .navigationTitle("Weather Report")
                .multilineTextAlignment(.leading)
            }
            .background(Color.mint)
            
        }
        //.background(Color.purple)
        
    }
    
    func search() {
        let geocoder = CLGeocoder()
        let place = location
        print(place)
        
        geocoder.geocodeAddressString(place) { geoData, _ in
            print(geoData ?? "")
  
            latt = geoData?[0].location?.coordinate.latitude ?? 0
            longg = geoData?[0].location?.coordinate.longitude ?? 0
    
        }
    }
 
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

