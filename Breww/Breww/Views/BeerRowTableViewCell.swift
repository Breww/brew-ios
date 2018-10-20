//
//  BeerRowTableViewCell.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class BeerRowTableViewCell: UITableViewCell {

    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    
    func formatCell(/*forBeer beer: Beer*/) {
        accessoryType = .disclosureIndicator
    }
}
