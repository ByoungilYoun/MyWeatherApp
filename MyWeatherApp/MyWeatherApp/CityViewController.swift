//
//  CityViewController.swift
//  MyWeatherApp
//
//  Created by 윤병일 on 2020/12/28.
//

import UIKit

class CityViewController : UIViewController {
  
  //MARK: - Property
  private let containerView : UIView = {
    let v = UIView()
    v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
    return v
  }()
  
  private let enterCityLabel : UILabel = {
    let label = UILabel()
    label.text = "Enter City"
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = .center
    return label
  }()
  
  private let textField : UITextField = {
    let textField = UITextField()
    textField.borderStyle = .line
    return textField
  }()
  
  private let searchButton : UIButton = {
    let bt = UIButton()
    bt.setTitle("Search", for: .normal)
    bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    bt.backgroundColor = .green
    bt.layer.cornerRadius = 8
    bt.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    return bt
  }()
  
  private let indicatorView : UIActivityIndicatorView = {
    let v = UIActivityIndicatorView()
    v.style = .medium
    v.color = .black
    return v
  }()
  
  private let statusLabel : UILabel = {
    let lb = UILabel()
    lb.text = "Status"
    lb.textAlignment = .center
    lb.font = UIFont.systemFont(ofSize: 16)
    lb.numberOfLines = 0
    return lb
  }()
  
  private let weatherManager = WeatherManager()
  
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
    configureUI()
    textField.becomeFirstResponder()
    setupGesture()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    statusLabel.isHidden = true
  }
  
  //MARK: - configureUI()
  private func configureUI() {
    view.addSubview(containerView)
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    let stackView = UIStackView(arrangedSubviews: [enterCityLabel, textField, searchButton, indicatorView ,statusLabel])
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
      containerView.widthAnchor.constraint(equalToConstant: 200),
      containerView.heightAnchor.constraint(equalToConstant: 200),
      
      stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      stackView.widthAnchor.constraint(equalToConstant: 180),
    ])
  }
  
  //MARK: - setupGesture()
  private func setupGesture() {
    let tapGesture  = UITapGestureRecognizer(target: self, action: #selector(dismissViewControlelr))
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }
  
  //MARK: - @objc func dissmissKeyboard()
  @objc func dismissViewControlelr() {
    dismiss(animated: true, completion: nil)
  }
  
  //MARK: - @objc func searchButtonTapped()
  @objc func searchButtonTapped() {
    statusLabel.isHidden = true
    guard let query = textField.text , !query.isEmpty else {
      showSearchError(text: "City cannot be empty. Please try again!")
      return
    }
    handleSearch(query: query)
  }
  
  //MARK: - func showSearchError()
  private func showSearchError(text : String) {
    statusLabel.isHidden = false
    statusLabel.textColor = .systemRed
    statusLabel.text = text
  }
  
  //MARK: - func searchForCity
  private func handleSearch(query : String) {
//    print("search : \(query)")
    indicatorView.startAnimating() // 애니메이션 스타트
    weatherManager.fetchWeather(city: query) { [weak self](result) in
      guard let this = self else {return}
      this.indicatorView.stopAnimating() // search 한뒤 가져오면 애니메이션 stop
      switch result {
      case .success(let model) :
        print(model.countryName)
        this.handleSearchSuccess(model: model)
      case .failure(let error) :
        this.showSearchError(text: error.localizedDescription)
      }
    }
  }
  
  private func handleSearchSuccess(model : WeatherModel) {
    statusLabel.isHidden = false
    statusLabel.textColor = .systemGreen
    statusLabel.text = "Success!"
  }
}

  //MARK: - UIGestureRecognizerDelegate
extension CityViewController : UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view == self.view
  }
  
}
