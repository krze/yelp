//
//  DealsCell.swift
//  Yelp
//
//  Created by iKreb Retina on 9/7/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealsCellDelegate {
    optional func dealsCell(DealsCell: DealsCell, didChangeValue value: Bool)
}

class DealsCell: UITableViewCell {

    @IBOutlet weak var dealsLabel: UILabel!
    @IBOutlet weak var dealsSwitch: UISwitch!
    
    weak var delegate: DealsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.dealsLabel.text = "Offering Deals"
        
        dealsSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        println("switch value changed")
        delegate?.dealsCell?(self, didChangeValue: dealsSwitch.on)
    }

}
