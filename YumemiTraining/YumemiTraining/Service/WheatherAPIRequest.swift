//
//  WheatherAPIRequest.swift
//  YumemiTraining
//
//  Created by HIROKI IKEUCHI on 2024/03/15.
//

import Foundation
import YumemiWeather

struct WheatherAPIRequest {
    let area: Area
    let date: String
    
    init?(area areaRawValue: String = "tokyo", date: String = "2020-04-01T12:00:00+09:00") {
        guard let area = Area(rawValue: "tokyo".capitalized) else {
            return nil
        }
        self.area = area
        self.date = date
    }
}

extension WheatherAPIRequest {
    var jsonString: String {
        """
{
    "area": "\(area)",
    "date": "\(date)"
}
"""
    }
}
