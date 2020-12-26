//
//  AppDelegate.swift
//  MyWeatherApp
//
//  Created by 윤병일 on 2020/12/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UINavigationController(rootViewController: WeatherViewController())
    window?.backgroundColor = .systemBackground
    window?.makeKeyAndVisible()
    return true
  }
}

