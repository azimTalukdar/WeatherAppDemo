//
//  WeatherTableViewCell.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
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
