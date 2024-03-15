//
//  ViewController.swift
//  YumemiTraining
//
//  Created by HIROKI IKEUCHI on 2024/03/15.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var wheatherImageView: UIImageView!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - View
    
    // MARK: - Helpers
}

// MARK: - API

extension ViewController {
    
    func loadWeather() async throws {
        guard let request = WheatherAPIRequest() else {
            return
        }
        let wheather = try await YumemiWeather.fetchWeather(request.jsonString)
        
        print(wheather)
    }
    
}

// MARK: - Actions

extension ViewController {
        
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func reloadButtonTapped(_ sender: UIButton) {
        Task {
            do {
                try await loadWeather()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
