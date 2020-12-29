//
//  Double+Extensions.swift
//  MyWeatherApp
//
//  Created by 윤병일 on 2020/12/27.
//

import Foundation

extension Double {
  
  func toString() -> String {
//    return "\(self)"  ->  Double 값을 String 으로 바꿔서 return 해준다.
    return String(format: "%.1f", self)
  }
  
  // Double 형식을 Int 형식으로 바꿔주는 함수 
  func toInt() -> Int {
    return Int(self)
  }
}
