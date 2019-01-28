//
//  weatherViewController.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import UIKit
import CoreLocation

class weatherViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTemprature: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMinTemprature: UILabel!
    @IBOutlet weak var lblMaxTemprature: UILabel!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var myTableView: UITableView!
    
    
//    let currenytLocation
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        
        myCollectionView.delegate = self
        myCollectionView .dataSource = self
        
        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func listTapped(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
        myVC.delegate = self
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    func getLocationFromList(_ dataModel:SearchedLocationModel) {
        print("Location got \(dataModel.name!)")
    }
}

extension weatherViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell_ = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        cell_.lblDay.text = "2PM"
        cell_.lblTemprature.text = "23"
        return cell_
    }
}

extension weatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_ = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        cell_.selectionStyle = .none
        
        cell_.lblDay.text = "Sat"
        cell_.lblMinTemprature.text = "22"
        cell_.lblMaxTemprature.text = "32"
        return cell_
    }
}

extension weatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        print("Location is \(locationValue.latitude), \(locationValue.longitude)")
        locationManager.stopUpdatingLocation()
    }
}
