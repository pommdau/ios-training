//
//  AreaResponse.swift
//  YumemiTraining
//
//  Created by HIROKI IKEUCHI on 2024/03/15.
//

import UIKit

/*
 レスポンスのJSON文字列の例:
 
 [
     {
         "area": "Tokyo",
         "info": {
             "max_temperature": 25,
             "date": "2020-04-01T12:00:00+09:00",
             "min_temperature": 7,
             "weather_condition": "cloudy"
         }
     }
 ]
 */

struct AreaResponse: Decodable {
    let infoList: [AreaInfo]
}


struct AreaInfo: Decodable {
    let area: String
    let info: WheatherInfo
}

struct WheatherInfo: Decodable {
    private enum CodingKeys: String, CodingKey {
        case condition = "weather_condition"
        case date
        case maxTemperature = "max_temperature"
        case minTemperature = "min_temperature"
    }
    
    let condition: String
    let date: String
    let maxTemperature: Int
    let minTemperature: Int
    
    var image: UIImage? {
        UIImage(named: "WhetherStatus/\(condition)")
    }
    
    var imageColor: UIColor {
        switch condition {
        case "cloudy":
            return .lightGray
        case "rainy":
            return .systemBlue
        case "sunny":
            return .systemRed
        default:
            fatalError("[Error] \(condition) is undefined")
        }
        
    }
}

