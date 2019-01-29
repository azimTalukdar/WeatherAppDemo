//
//  weatherViewController.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class weatherViewController: UIViewController {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet weak var viewToolBar: UIView!
    
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
    
    var userInfo: UserModel!
    
    var mainDataModel: WeatherModel!
    
    var locationName: String!
    var locationLat: String!
    var locationLng: String!
    
//    let currenytLocation
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        
        myCollectionView.delegate = self
        myCollectionView .dataSource = self
        
//        getLocation()
        loadFromUserdefaul()
        if locationName == nil{
            displayLocationAlert()
        }else{
            getLocationNew()
        }
        setUpProfile()
        viewCollection.layer.borderWidth = 1.0
        viewCollection.layer.borderColor = UIColor.white.cgColor
        
        viewToolBar.layer.borderWidth = 1.0
        viewToolBar.layer.borderColor = UIColor.white.cgColor
        
        
        imgProfile.layer.borderWidth = 0.5
        imgProfile.layer.borderColor = UIColor.white.cgColor
        
        addMotionEffect()
    }
    
    func addMotionEffect() {
        let min = CGFloat(-100)
        let max = CGFloat(100)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion] //addMotionEffect()
        
        imgBackground.addMotionEffect(motionEffectGroup)
    }
    
    func displayLocationAlert() {
        let alertVC = UIAlertController.init(title: "Oops!!!", message: "Looks like you have not selected any location", preferredStyle: .alert)
        let okBtn = UIAlertAction.init(title: "Set Location", style: .default) { (action) in
            self.openCityListVC()
        }
        alertVC.addAction(okBtn)
        present(alertVC, animated: true, completion: nil)
    }
    
    func loadFromUserdefaul() -> Void {
        if UserDefaults.standard.object(forKey: "locationName") != nil {
            locationName = UserDefaults.standard.object(forKey: "locationName") as! String
            locationLat = UserDefaults.standard.object(forKey: "locationLat") as! String
            locationLng = UserDefaults.standard.object(forKey: "locationLng") as! String
        }
    }
    
    func setUpProfile() -> Void {
        imgProfile.sd_setImage(with: URL(string: userInfo.imageUrl), placeholderImage: UIImage(named: ""))
        lblName.text = userInfo.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func listTapped(_ sender: Any) {
        openCityListVC()
    }
    
    func openCityListVC() {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
        myVC.delegate = self
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func getLocationFromList(_ dataModel:SearchedLocationModel) {
        print("Location got \(dataModel.name!)")
        UserDefaults.standard.setValue(dataModel.name, forKey: "locationName")
        UserDefaults.standard.setValue("\(dataModel.latitude)", forKey: "locationLat")
        UserDefaults.standard.setValue("\(dataModel.longitude)", forKey: "locationLng")
        loadFromUserdefaul()
        getLocationNew()
    }
    
    fileprivate func getLocationNew()  {
        let urlString = "https://api.darksky.net/forecast/3b4607b5d057c59fdff1eeece940dd90/\(locationLat!),\(locationLng!)?units=si"
        print("url string \(urlString)")
        HttpClientApi.instance().makeAPICallPOST(strAPI: urlString, params: nil, method: .GET, isHUD: true, success: { (response) in
            
            OperationQueue.main.addOperation({
                do{
                    self.mainDataModel = try JSONDecoder().decode(WeatherModel.self, from: response)
                    self.updateCurrentTemp()
                }catch{
                    print(error)
                }
            })
            
        }) { (response) in
        }
    }
    
    func updateCurrentTemp() -> Void {
        lblLocation.text = locationName
        lblDescription.text = mainDataModel.currently.summary
        lblTemprature.text = "\(mainDataModel.currently.temperature)°"
        lblMinTemprature.text = "\(mainDataModel.daily.data[0].apparentTemperatureMin)°"
        lblMaxTemprature.text = "\(mainDataModel.daily.data[0].apparentTemperatureMax)°"
        
        myTableView.reloadData()
        myCollectionView.reloadData()
    }

}

extension weatherViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainDataModel == nil ? 0 : 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell_ = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        cell_.current = mainDataModel.hourly.data[indexPath.row]
        return cell_
    }
}

extension weatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDataModel == nil ? 0 : mainDataModel.daily.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_ = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        cell_.selectionStyle = .none
        cell_.daily = mainDataModel.daily.data[indexPath.row]
        return cell_
    }
}



