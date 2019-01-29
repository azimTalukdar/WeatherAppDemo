//
//  WeatherModel.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    let latitude, longitude: Double
    let timezone: String
    let currently: Currently
    let minutely: Minutely?
    let hourly: Hourly
    let daily: Daily
    let flags: Flags
//    let offset: Int?
}

struct Currently: Codable {
    let time: Int
    let summary: String
    let icon: String
    let nearestStormDistance, nearestStormBearing: Int?
    let precipIntensity, precipProbability, temperature, apparentTemperature: Double
    let dewPoint, humidity, pressure, windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility, ozone: Double
    let precipType: String?
}

struct Daily: Codable {
    let summary: String
    let icon: String
    let data: [DailyDatum]
}

struct DailyDatum: Codable {
    let time: Int
    let summary, icon: String
    let sunriseTime, sunsetTime: Int
    let moonPhase, precipIntensity, precipIntensityMax: Double
    let precipIntensityMaxTime: Int
    let precipProbability, temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint, humidity, pressure, windSpeed: Double
    let windGust: Double
    let windGustTime, windBearing: Int
    let cloudCover: Double
    let uvIndex, uvIndexTime: Int
    let visibility, ozone, temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
    let precipType: String?
}

struct Flags: Codable {
    let sources: [String]
    let nearestStation: Double
    let units: String
    
    enum CodingKeys: String, CodingKey {
        case sources
        case nearestStation = "nearest-station"
        case units
    }
}

struct Hourly: Codable {
    let summary: String
    let icon: String
    let data: [Currently]
}

struct Minutely: Codable {
    let summary: String
    let icon: String
    let data: [MinutelyDatum]
}

struct MinutelyDatum: Codable {
    let time: Int
    let precipProbability, precipIntensity: Double
}
