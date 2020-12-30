//
//  WeatherManager.swift
//  MyWeatherApp
//
//  Created by 윤병일 on 2020/12/26.
//

import Foundation
import Alamofire

enum WeatherError : Error, LocalizedError {
  case unknown
  case invalidCity
  
  var errorDescription: String? {
    switch self {
    case .unknown:
      return "Hey, this is an unknown error!"
    case .invalidCity :
      return "This is invalid city. Please try again."
    }
  }
  
  
}

struct WeatherManager {

  //MARK: - API_Key
  private let API_Key = "41de2c2b37f3ae02bd1f01e5870f6c69"
  
  //MARK: - fetchWeather ()
  func fetchWeather (city : String, completion : @escaping (Result<WeatherModel, Error>) -> Void) {
    let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
    let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
    let urlString = String(format: path, query, API_Key)
    
    AF.request(urlString).responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (response) in
      switch response.result {
      case .success(let weatherData) :
        let model = weatherData.model
        completion(.success(model))
      case .failure(let error) :
        if response.response?.statusCode == 404 {
          let invalidCityError = WeatherError.invalidCity
          completion(.failure(invalidCityError))
        } else {
          completion(.failure(error))
        } 
      }
    }
  }
}
