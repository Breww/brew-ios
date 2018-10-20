//
//  HomeViewController.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 55, height: 55)
    }
}

class HomeViewController: UIViewController {
    @IBOutlet weak var topPicksView: UIView!
    @IBOutlet weak var topPickStackView: UIStackView!
    @IBOutlet weak var topPicksViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topPicksStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var topPicksViewExpandButton: UIButton!
    
    @IBOutlet weak var catalogueView: UIView!
    
    var isHorizontalStack: Bool {
        return topPickStackView.axis == .horizontal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewElements()
    }
    
    private func setupViewElements() {
        for button in topPickStackView.arrangedSubviews {
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
        }
        
        topPickStackView.alignment = .leading
        topPicksStackViewWidthConstraint.constant = UIScreen.main.bounds.width - 16
        
        topPicksView.layer.masksToBounds = false
        topPicksView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topPicksView.layer.shadowRadius = 1
        topPicksView.layer.shadowOpacity = 0.2
        topPicksView.layer.shadowColor = UIColor.black.cgColor
    }
    
    @IBAction func topPickButtonTapped(_ sender: CustomButton) {
        print(sender.tag)
    }
    
    @IBAction func expandButtonTapped(_ sender: UIButton) {
        if isHorizontalStack {
            topPicksViewHeightConstraint.constant = 426
            topPicksStackViewWidthConstraint.constant = 82
            topPickStackView.axis = .vertical
            topPickStackView.distribution = .fillEqually
            topPickStackView.spacing = 20
//            catalogueView.isHidden = true
        } else {
            topPicksViewHeightConstraint.constant = 126
            topPicksStackViewWidthConstraint.constant = UIScreen.main.bounds.width - 16
            topPickStackView.axis = .horizontal
            topPickStackView.distribution = .equalSpacing
            topPickStackView.spacing = 0
//            catalogueView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
//            self.topPicksViewExpandButton.titleLabel?.text = self.isHorizontalStack ? "More" : "Close"
        }
    }
}
