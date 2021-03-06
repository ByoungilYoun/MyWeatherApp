//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by 윤병일 on 2020/12/25.
//

import UIKit
import SkeletonView
import CoreLocation
import Loaf

 //MARK: - WeatherViewControllerDelegate - childView 인 CityViewController 의 내용을 가져와서 업데이트를 하기 위한 프로토콜
protocol  WeatherViewControllerDelegate : class {
  func didUpdateWeatherFromSearch (model : WeatherModel)
}

class WeatherViewController: UIViewController {
  
  lazy var stackView : UIStackView = {
    var v = UIStackView()
    v.axis = .vertical
    v.spacing = 10
    return v
  }()
  
  lazy var conditionalImageView : UIImageView = {
    var v = UIImageView()
    v.isSkeletonable = true
    v.clipsToBounds = true
    v.contentMode = .scaleAspectFit
    return v
  }()
  
  lazy var temperatureLabel : UILabel = {
    var l = UILabel()
    l.font = UIFont.boldSystemFont(ofSize: 26)
    l.textAlignment = .center
    l.isSkeletonable = true
    l.textColor = .lightGray
    return l
  }()
  
  lazy var conditionLabel : UILabel = {
    var l = UILabel()
    l.font = UIFont.systemFont(ofSize: 26)
    l.textAlignment = .center
    l.isSkeletonable = true
    l.numberOfLines = 0
    return l
  }()
  
  private let weatherManager = WeatherManager()
  
  private lazy var locationManager : CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    return manager
  }()
  
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavi()
    configureUI()
    fetchWeather(byCity: "berlin")
  }
  
  //MARK: - setNavi()
  private func setNavi() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName : "plus"), style: .plain, target: self, action: #selector(addCityBtnTapped))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(locationBtnTapped))
  }
  
  //MARK: - configureUI()
  private func configureUI() {
    view.addSubview(stackView)
    
    [conditionalImageView, temperatureLabel, conditionLabel].forEach {
      stackView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250),
      
      conditionalImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
      conditionalImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
      conditionalImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
      conditionalImageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -80),
      
      temperatureLabel.topAnchor.constraint(equalTo: conditionalImageView.bottomAnchor),
      temperatureLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
      temperatureLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
      temperatureLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -40),
      
      conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
      conditionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
      conditionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
    ])
  }
  
  //MARK: - fetchWeather(byLocation)
  private func fetchWeather(byLocation location : CLLocation) {
    showAnimation()
    
    let lat = location.coordinate.latitude
    let lon = location.coordinate.longitude
    weatherManager.fetchWeather(lat: lat, lon: lon) { [weak self] (result) in
      guard let this = self else {return}
      this.handleResult(result)
    }
  }
  
  //MARK: - func fetchWeather()
  private func fetchWeather(byCity city : String) {
    showAnimation()
    
    weatherManager.fetchWeather(city: city) { [weak self](result) in
      guard let this = self else {return}
      this.handleResult(result)
    }
  }

  //MARK: - func handleResult()
  private func handleResult(_ result : Result<WeatherModel, Error>) {
    switch result {
    case .success(let model) :
      updateView(with: model)
    case .failure(let error) :
      handleError(error)
    }
  }
  
  //MARK: - func handleError()
  private func handleError(_ error : Error) {
    hideAnimation()
    
    navigationItem.title = ""
    conditionalImageView.image = UIImage(named: "imSad")
    temperatureLabel.text = "Oops"
    conditionLabel.text = "Something went wrong.\nPlease try again."
    Loaf(error.localizedDescription, state: .error, location: .top, sender: self).show()
  }
  
  
  //MARK: - func updateView()
  private func updateView (with model : WeatherModel) {
    hideAnimation()
    temperatureLabel.text = model.temp.toString().appending("°C")
    conditionLabel.text = model.conditionDescription
    navigationItem.title = model.countryName
    
    conditionalImageView.image = UIImage(named: model.conditionImage)
  }
    //MARK: - func showAnimation()
  private func showAnimation() {
    conditionalImageView.showAnimatedGradientSkeleton()
    temperatureLabel.showAnimatedGradientSkeleton()
    conditionLabel.showAnimatedGradientSkeleton()
  }
  
  //MARK: - func hideAnimation()
  private func hideAnimation() {
    conditionalImageView.hideSkeleton()
    temperatureLabel.hideSkeleton()
    conditionLabel.hideSkeleton()
  }
  
  //MARK: - @objc func addCityBtnTapped()
  @objc func addCityBtnTapped() {
    let controller = CityViewController()
    controller.modalPresentationStyle = .fullScreen
    controller.modalTransitionStyle = .crossDissolve
    controller.delegate = self // controller(CityViewController) 의 delegate 는 self(WeatherViewController)
    present(controller, animated: true, completion: nil)
  }
  
  //MARK: - @objc func locationBtnTapped()
  @objc func locationBtnTapped() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.requestLocation()
    case .notDetermined :
      // 부인되면 request 로 물어봐야한다.
      locationManager.requestWhenInUseAuthorization()
      locationManager.requestLocation()
    default:
      promptForLocationPermission()
    }
  }
  
  //MARK: - promptForLocationPermission()
  private func promptForLocationPermission() {
    let alertController = UIAlertController(title: "Requires Location Permission", message: "Would you like to enable location permission in Settings?", preferredStyle: .alert)
    let enableAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
      guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {return}
      UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(enableAction)
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

  //MARK: - WeatherViewControllerDelegate 
extension WeatherViewController : WeatherViewControllerDelegate {
  func didUpdateWeatherFromSearch(model: WeatherModel) {
    presentedViewController?.dismiss(animated: true, completion: { [weak self] in
      guard let this = self else {return}
      this.updateView(with: model)
    })
    
  }
}

  //MARK: - CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      manager.stopUpdatingLocation()
      fetchWeather(byLocation: location)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    handleError(error)
  }
}
 
