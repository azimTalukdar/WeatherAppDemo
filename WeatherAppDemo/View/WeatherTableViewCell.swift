//
//  WeatherTableViewCell.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    
    var dailyViewModel: DailyDatumViewModel! {
        didSet {
            lblDay.text = dailyViewModel.day
            lblMinTemprature.text = dailyViewModel.minTemprature
            lblMaxTemprature.text = dailyViewModel.maxTemprature
            imgWeatherIcon.image = UIImage(named: dailyViewModel.icon)
        }
    }
    
    
    var daily: DailyDatum! {
        didSet {
            lblDay.text = (daily.time).getTimeFromUTC()
            lblMinTemprature.text = "\(daily.apparentTemperatureMin)°"
            lblMaxTemprature.text = "\(daily.apparentTemperatureMax)°"
            imgWeatherIcon.image = UIImage(named: daily.icon)
        }
    }
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var lblMinTemprature: UILabel!
    @IBOutlet weak var lblMaxTemprature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
