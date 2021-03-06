//
//  BeerCollectionViewCell.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    func formatCell(forBeer beer: Beer) {
        imageView.image = beer.primaryImage
        nameLabel.text = beer.name
        styleLabel.text = beer.style
        
        DispatchQueue.main.async {
            if beer.positiveRating ?? false {
                self.ratingImage.tintColor = UIColor(named: "PositiveColor")
                self.ratingImage.image = UIImage(named: "ThumbsUp")
            } else {
                self.ratingImage.tintColor = UIColor(named: "RightGradient")
                self.ratingImage.image = UIImage(named: "ThumbsDown")
            }
        }
        
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
