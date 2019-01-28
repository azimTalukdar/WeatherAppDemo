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

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
var dataArr = [SearchedLocationModel]()

class CityListViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    var delegate : weatherViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        loadMyData()
        // Do any additional setup after loading the view.
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButton
        
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

    @IBAction func addMyLocationTapped(_ sender: Any) {
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
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("place lat: \(place.coordinate.latitude)")
        print("place lat: \(place.coordinate.longitude)")
        
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
        }catch{
            print("Error in saving City \(error)")
        }
    }
    
}
