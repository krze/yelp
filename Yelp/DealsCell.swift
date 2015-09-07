//
//  DealsCell.swift
//  Yelp
//
//  Created by iKreb Retina on 9/7/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class DealsCell: UITableViewCell {

    @IBOutlet weak var dealsLabel: UILabel!
    @IBOutlet weak var dealsSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.dealsLabel.text = "Offering Deals"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
