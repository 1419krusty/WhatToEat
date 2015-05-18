//
//  MealCellTableViewCell.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/17/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {

   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var ratingImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
