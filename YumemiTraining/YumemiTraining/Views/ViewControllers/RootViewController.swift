//
//  RootViewController.swift
//  YumemiTraining
//
//  Created by HIROKI IKEUCHI on 2024/03/16.
//

import UIKit

class RootViewController: UIViewController {
    
    var weatherViewController: WeatherViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewController = storyboard!.instatiateWeatherViewController()!
        weatherViewController.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        present(weatherViewController, animated: true)
    }
    
}
