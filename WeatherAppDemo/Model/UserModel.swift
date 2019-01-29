//
//  UserModel.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import Foundation

class UserModel {
    var name: String
    var imageUrl: String
    
    init(name: String, imageUrl:String) {
        self.name = name
        self.imageUrl = imageUrl
    }
}
