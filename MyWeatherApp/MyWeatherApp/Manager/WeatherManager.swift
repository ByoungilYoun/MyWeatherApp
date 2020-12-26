//
//  WeatherManager.swift
//  MyWeatherApp
//
//  Created by 윤병일 on 2020/12/26.
//

import Foundation
import Alamofire

struct WeatherManager {

  //MARK: - API_Key
  private let API_Key = "41de2c2b37f3ae02bd1f01e5870f6c69"
  
  //MARK: - fetchWeather ()
  func fetchWeather (city : String, completion : @escaping (Result<WeatherData, Error>) -> Void) {
    let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
    let path = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
    let urlString = String(format: path, query, API_Key)
    
    AF.request(urlString).responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (response) in
      switch response.result {
      case .success(let weatherData) :
        completion(.success(weatherData))
      case .failure(let error) :
        completion(.failure(error))
      }
    }
  }
}
