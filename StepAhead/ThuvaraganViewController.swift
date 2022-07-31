//
//  ThuvaraganViewController.swift
//  StepAhead
//
//  Created by CoopStudent on 7/30/22.
//

import UIKit

class ThuvaraganViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Coupon {
        let image: String!
        let placeholdler: String!
        let points: String!
    }
    
    let coupons = [Coupon(image: "Presto_Card", placeholdler: "Presto", points: "1000"), Coupon(image: "Placeholder", placeholdler: "Local Brampton Restaurant Promo Code", points: "300"),Coupon(image: "Placeholder", placeholdler: "Local Brampton Restaurant Promo Code", points: "100"), Coupon(image: "Placeholder", placeholdler: "Local Brampton Restaurant Promo Code", points: "200"), Coupon(image: "Placeholder", placeholdler: "Local Brampton Restaurant Promo Code", points: "400")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRevealSreen(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "2nd_vc") as! SecondViewController
        
        present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ShopTableViewCell
        let coupon = coupons[indexPath.row]
        
        cell?.couponImage.image = UIImage(named: coupon.image)
        cell?.placeholder.text = coupon.placeholdler
        cell?.points.text = coupon.points
        
        return cell!
        
    }


}

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
}
