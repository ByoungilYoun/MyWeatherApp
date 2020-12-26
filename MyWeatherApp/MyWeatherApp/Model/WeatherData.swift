//
//  WeatherData.swift
//  MyWeatherApp
//
//  Created by 윤병일 on 2020/12/26.
//

import Foundation

struct WeatherData : Decodable {
  
  let name : String
  let main : Main
  let weather : [Weather]
}

struct Main : Decodable {
  let temp : Double
}


struct Weather : Decodable {
  let id : Int
  let main : String
  let description : String
}
