//
//  IshnuViewController.swift
//  StepAhead
//
//  Created by Ishnu Suresh on 2022-07-30.
//

import UIKit

class IshnuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bikeTableView: UITableView!
    
    
    let myData = [BikeData(image: "SuperCycle", bikeBrand: "SuperCycle", bikePrice: "$15/Hour", location: "15 Example Road, Brampton, Ontario", description: " Gray and Red SuperCyle. Working Brakes and Headlights. Can be used by everyone of any age. Looking to rent for $15 per hour, from 8:00 AM to 5:00 PM."), BikeData(image: "SuperCycle", bikeBrand: "SuperCycle", bikePrice: "$15/Hour", location: "15 Example Road, Brampton, Ontario", description: " Gray and Red SuperCyle. Working Brakes and Headlights. Can be used by everyone of any age. Looking to rent for $15 per hour, from 8:00 AM to 5:00 PM."), BikeData(image: "SuperCycle", bikeBrand: "SuperCycle", bikePrice: "$15/Hour", location: "15 Example Road, Brampton, Ontario", description: " Gray and Red SuperCyle. Working Brakes and Headlights. Can be used by everyone of any age. Looking to rent for $15 per hour, from 8:00 AM to 5:00 PM."), BikeData(image: "SuperCycle", bikeBrand: "SuperCycle", bikePrice: "$15/Hour", location: "15 Example Road, Brampton, Ontario", description: " Gray and Red SuperCyle. Working Brakes and Headlights. Can be used by everyone of any age. Looking to rent for $15 per hour, from 8:00 AM to 5:00 PM."), BikeData(image: "SuperCycle", bikeBrand: "SuperCycle", bikePrice: "$15/Hour", location: "15 Example Road, Brampton, Ontario", description: " Gray and Red SuperCyle. Working Brakes and Headlights. Can be used by everyone of any age. Looking to rent for $15 per hour, from 8:00 AM to 5:00 PM."), BikeData(image: "SuperCycle", bikeBrand: "SuperCycle", bikePrice: "$15/Hour", location: "15 Example Road, Brampton, Ontario", description: " Gray and Red SuperCyle. Working Brakes and Headlights. Can be used by everyone of any age. Looking to rent for $15 per hour, from 8:00 AM to 5:00 PM.")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bikeTableView.delegate = self
        bikeTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BikeTableViewCell
        let bike = myData[indexPath.row]
        cell?.bikeImage.image = UIImage(named: bike.image)
        cell?.brandLabel.text = "Brand: " + bike.bikeBrand
        cell?.priceLabel.text = "Price: " + bike.bikePrice
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "DetailSegue"){
            let indexPath = self.bikeTableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? PopUpViewController
            
            let selectedBike = myData[indexPath.row]
            
            tableViewDetail!.selectedBike = selectedBike
            
            self.bikeTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

