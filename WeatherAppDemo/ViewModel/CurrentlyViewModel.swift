//
//  CurrentlyViewModel.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 29/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import Foundation

struct CurrentlyViewModel {
    
    let day: String
    let icon: String
    let temprature: String
    
    
    init(currentModel: Currently) {
        self.day = (currentModel.time).getTimeFromUTC()
        self.icon = currentModel.icon
        self.temprature = "\(currentModel.temperature)°"
    }
}
