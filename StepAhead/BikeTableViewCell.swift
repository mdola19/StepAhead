//
//  BikeTableViewCell.swift
//  StepAhead
//
//  Created by CoopStudent on 2022-07-31.
//

import UIKit

class BikeTableViewCell: UITableViewCell {

    @IBOutlet weak var bikeImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
