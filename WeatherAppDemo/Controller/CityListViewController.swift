//
//  CityListViewController.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreData
import CoreLocation

protocol CityDelegate {
//    var delegate: UIViewController?{get set}
    func getLocationFromList(_ dataModel:SearchedLocationModel)
}

class CityListViewController: UIViewController {
    
    
    @IBOutlet weak var viewToolBar: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dataArr = [SearchedLocationModel]()
    let locationManager = CLLocationManager()
    @IBOutlet weak var myTableView: UITableView!
    var delegate : CityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        loadMyData()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        
        viewToolBar.layer.borderWidth = 1.0
        viewToolBar.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        
    }

    @objc func addTapped() {
        print("addTapped")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func loadMyData(){
        let request : NSFetchRequest<SearchedLocationModel> = SearchedLocationModel.fetchRequest()
        do {
            dataArr = try context.fetch(request)
        } catch  {
            print("error loading data- \(error)")
        }
        
        myTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addCustomeLocation(_ sender: Any) {
        addTapped()
    }
    
    @IBAction func addMyLocationTapped(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_ = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as! CityListTableViewCell
        cell_.lblCityName.text = dataArr[indexPath.row].name
        return cell_
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.getLocationFromList(dataArr[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}

extension CityListViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        /*
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("place lat: \(place.coordinate.latitude)")
        print("place lat: \(place.coordinate.longitude)")
        */
        let searchModel = SearchedLocationModel(context: context)
        searchModel.name = place.name
        searchModel.latitude = place.coordinate.latitude
        searchModel.longitude = place.coordinate.longitude
        
        saveLocation()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    fileprivate func saveLocation()
    {
        do{
        try context.save()
            loadMyData()
        }catch{
            print("Error in saving City \(error)")
        }
        
    }
    
}

extension CityListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        print("Location is \(locationValue.latitude), \(locationValue.longitude)")
        getAddressFromLatLon(pdblLatitude: locationValue.latitude, withLongitude: locationValue.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        //21.228124
        let lon: Double = pdblLongitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let place_ = placemarks! as [CLPlacemark]
                
                if place_.count > 0 {
                    let place_ = placemarks![0]
                    /*
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                     */
                    
                    if !self.someEntityExists(name: place_.subLocality!) {
                        let searchModel = SearchedLocationModel(context: self.context)
                        searchModel.name = place_.subLocality
                        searchModel.latitude = lat
                        searchModel.longitude = lon
                        self.saveLocation()
                    }else
                    {
                        self.showAlert()
                    }
                    
                }
        })
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Sorry!!!", message: "Location is already added", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
        
    }
    
    func someEntityExists(name: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchedLocationModel")
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do{
            let count = try context.count(for: request)
            if(count == 0){
                return false
            }
            else{
                return true
            }
        }
        catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }
}
