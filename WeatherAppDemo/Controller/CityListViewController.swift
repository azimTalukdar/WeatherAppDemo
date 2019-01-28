//
//  CityListViewController.swift
//  WeatherAppDemo
//
//  Created by GENEXT-PC on 28/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        // Do any additional setup after loading the view.
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButton
        
    }

    @objc func addTapped() {
        print("addTapped")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_ = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as! CityListTableViewCell
        cell_.lblCityName.text = "Mumbai"
        return cell_
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
}
