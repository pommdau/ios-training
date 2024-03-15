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
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!

    private var wheatherInfo: WheatherInfo? {
        didSet {
            configureUI()
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            try? await loadWeather()
        }
    }
    
    // MARK: - View
    
    private func configureUI() {
        guard let wheatherInfo else {
            return
        }
        wheatherImageView.image = wheatherInfo.image
        wheatherImageView.tintColor = wheatherInfo.imageColor
        minTemperatureLabel.text = "\(wheatherInfo.minTemperature)℃"
        maxTemperatureLabel.text = "\(wheatherInfo.maxTemperature)℃"
    }
    
    // MARK: - Helpers
}

// MARK: - API

extension ViewController {
    
    func loadWeather() async throws {
        guard let request = WheatherAPIRequest() else {
            return
        }
        
        let response = try YumemiWeather.fetchWeather(request.jsonString)
        let wheatherInfo = try JSONDecoder().decode(WheatherInfo.self, from: response.data(using: .utf8)!)
        self.wheatherInfo = wheatherInfo
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
