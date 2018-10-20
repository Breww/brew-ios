//
//  SelectionCollectionViewCell.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-19.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class SelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var labelView: UIView!
    
    func formatCell(name: String) {
        nameLabel.text = name
        labelView.layer.borderWidth = 2
        labelView.layer.borderColor = UIColor.black.cgColor
        labelView.layer.cornerRadius = 6
    }
    
    func selectCell() {
        labelView.layer.borderColor = UIColor(named: "BlueButton")?.cgColor
        nameLabel.textColor = UIColor(named: "BlueButton")
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
