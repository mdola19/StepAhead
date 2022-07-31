//
//  ShopTableViewCell.swift
//  StepAhead
//
//  Created by CoopStudent on 7/30/22.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var couponImage: UIImageView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var points: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
