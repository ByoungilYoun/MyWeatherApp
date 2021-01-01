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
  case custom(description : String)
  
  var errorDescription: String? {
    switch self {
    case .unknown:
      return "Hey, this is an unknown error!"
    case .invalidCity :
      return "This is invalid city. Please try again."
    case .custom(let description) :
      return description
    }
  }
  
  
}

struct WeatherManager {

  //MARK: - API_Key
  private let API_Key = "41de2c2b37f3ae02bd1f01e5870f6c69"
  
  func fetchWeather (lat : Double,  lon : Double ,completion : @escaping (Result<WeatherModel, Error>) -> Void) {
    
    let path = "https://api.openweathermap.org/data/2.5/weather?&appid=%@&units=metric&lat=%f&lon=%f"
    let urlString = String(format: path, API_Key, lat, lon)
    
    handleRequest(urlString: urlString, completion: completion)
  }
  
  
  
  //MARK: - fetchWeather ()
  func fetchWeather (city : String, completion : @escaping (Result<WeatherModel, Error>) -> Void) {
    let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
    let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
    let urlString = String(format: path, query, API_Key)
    
    handleRequest(urlString: urlString, completion: completion)
    } 
  
  private func handleRequest(urlString : String, completion : @escaping (Result<WeatherModel, Error>) -> Void) {
    AF.request(urlString).validate().responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (response) in
      switch response.result {
      case .success(let weatherData) :
        let model = weatherData.model
        completion(.success(model))
      case .failure(let error) :
        if let err = getWeatherError(error: error, data: response.data) {
          completion(.failure(err))
        } else {
          completion(.failure(error) )
        }
      }
    }
  }
  
  
  private func getWeatherError(error : AFError, data : Data?) -> Error? {
    if error.responseCode == 400, let data = data, let failure = try? JSONDecoder().decode(WeatherDataFailure.self, from: data) {
      let message = failure.message
      return WeatherError.custom(description: message)
    } else {
      return nil
    }
  }
}
