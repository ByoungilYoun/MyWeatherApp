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
    return lb
  }()
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
    configureUI()
//    indicatorView.startAnimating()
    indicatorView.isHidden = false
    textField.becomeFirstResponder()
    setupGesture()
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
    
  }
}

extension CityViewController : UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view == self.view
  }
  
}
