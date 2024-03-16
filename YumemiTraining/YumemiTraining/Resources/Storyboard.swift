//
//  Storyboard.swift
//  YumemiTraining
//
//  Created by HIROKI IKEUCHI on 2024/03/16.
//

import UIKit

extension UIStoryboard {
    
    static var weatherViewControllerID = "WheatherViewController"
    
    
    /// Instantiate weather view controller.
    /// - Returns: An instance of weather view controller.
    func instatiateWeatherViewController() -> ViewController? {
        guard let viewController = instantiateViewController(identifier: Self.weatherViewControllerID) as? ViewController else {
            return nil
        }
        
        return viewController
    }
    
}
