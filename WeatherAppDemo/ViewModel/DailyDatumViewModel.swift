//
//  File.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 29/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import Foundation

struct DailyDatumViewModel {

    let day: String
    let icon: String
    let minTemprature: String
    let maxTemprature: String
    
    
    init(dailyModel: DailyDatum) {
        self.day = (dailyModel.time).getDateStringFromUTC()
        self.icon = dailyModel.icon
        self.minTemprature = "\(dailyModel.temperatureMin)°"
        self.maxTemprature = "\(dailyModel.temperatureMax)°"
    }
}
