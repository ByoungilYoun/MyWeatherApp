//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by 윤병일 on 2020/12/25.
//

import UIKit

class WeatherViewController: UIViewController {
  
  lazy var stackView : UIStackView = {
    var v = UIStackView()
    v.axis = .vertical
    v.spacing = 10
    return v
  }()
  
  lazy var conditionalImageView : UIImageView = {
    var v = UIImageView()
    v.image = UIImage(named: "imClouds")
    v.clipsToBounds = true
    v.contentMode = .scaleAspectFit
    return v
  }()
  
  lazy var temperatureLabel : UILabel = {
    var l = UILabel()
    l.text = "24°C"
    l.font = UIFont.boldSystemFont(ofSize: 26)
    l.textAlignment = .center
    l.textColor = .lightGray
    return l
  }()
  
  lazy var conditionLabel : UILabel = {
    var l = UILabel()
    l.text = "Mostly Cloudy"
    l.font = UIFont.systemFont(ofSize: 26)
    l.textAlignment = .center
    return l
  }()
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavi()
    configureUI()
  }
  
  //MARK: - setNavi()
  private func setNavi() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName : "plus"), style: .plain, target: self, action: #selector(addBtnTapped))
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
      conditionLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
    ])
  }
  
  //MARK: - @objc func addBtnTapped()
  @objc func addBtnTapped() {
    print("123")
  }
  
  //MARK: - @objc func locationBtnTapped()
  @objc func locationBtnTapped() {
    print("456")
  }
}

