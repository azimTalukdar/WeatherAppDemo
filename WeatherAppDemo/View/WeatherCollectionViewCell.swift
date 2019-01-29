//
//  WeatherCollectionViewCell.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    var viewModel: CurrentlyViewModel! {
        didSet {
            lblDay.text = viewModel.day
            lblTemprature.text = viewModel.temprature
            imgWeatherIcon.image = UIImage(named: viewModel.icon)
        }
    }
    
    var current: Currently! {
        didSet {
            lblDay.text = (current.time).getTimeFromUTC()
            lblTemprature.text = "\(current.temperature)°"
            imgWeatherIcon.image = UIImage(named: current.icon)
        }
    }
    
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var lblTemprature: UILabel!
    
    
    
}
