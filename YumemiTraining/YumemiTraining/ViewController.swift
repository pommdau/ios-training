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
        
        reloadButtonTapped(self)
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
    
    private func presentErrorModal(_ error: Error) {
        var errorMessage = ""
        if let error = error as? YumemiWeatherError {
            switch error {
            case .invalidParameterError:
                errorMessage = "指定されたパラメータが不正です。デベロッパに問い合わせてください。"
            case .unknownError:
                errorMessage = "時間をおいてから再度実行してください。"
            }
        } else {
            errorMessage = error.localizedDescription
        }
        
        let alert = UIAlertController(
            title: "天気情報の取得ができませんでした",
            message: errorMessage,
            preferredStyle: .alert)
        
        
        let retryAction = UIAlertAction(title: "リトライ", style: .default) { _ in
            self.reloadButtonTapped(self)
        }
        
        let okAction = UIAlertAction(title: "閉じる", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        alert.addAction(retryAction)
                
        present(alert, animated: true, completion: nil)
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
        
    @IBAction func closeButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        Task {
            do {
                try await loadWeather()
            } catch {
                presentErrorModal(error)
            }
        }
    }
}
