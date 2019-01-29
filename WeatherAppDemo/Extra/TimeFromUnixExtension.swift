//
//  DoubleExtension.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 29/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import Foundation

extension Int {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    func getTimeFromUTC() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh a"
        return dateFormatter.string(from: date)
    }
}
