//
//  PopUpViewController.swift
//  StepAhead
//
//  Created by Ishnu Suresh on 2022-07-30.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var Description: UILabel!
    
    
    var selectedBike: BikeData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brand.text = "Brand: " + selectedBike.bikeBrand
        image.image = UIImage(named: selectedBike.image)
        price.text = "Price: " + selectedBike.bikePrice
        location.text = "Location: " + selectedBike.location
        Description.text = "Description: " + selectedBike.description
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
