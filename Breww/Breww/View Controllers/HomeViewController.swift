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
    @IBOutlet weak var catalogueCollectionView: UICollectionView!
    
    @IBOutlet weak var recommendedTableView: UITableView!
    
    private var isHorizontalStack: Bool {
        return topPickStackView.axis == .horizontal
    }
    
    private var scannedBeers: [Beer] = [Beer.init(name: "Stella Artois", style: "Lager", description: "jdln", primaryImage: UIImage(named: "logo")!, positiveRating: true), Beer.init(name: "Stella Artois", style: "Lager", description: "jdln", primaryImage: UIImage(named: "logo")!, positiveRating: false), Beer.init(name: "Stella Artois", style: "Lager", description: "jdln", primaryImage: UIImage(named: "logo")!, positiveRating: true)]
    private var recommendedBeers: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catalogueCollectionView.delegate = self
        catalogueCollectionView.dataSource = self
        
        recommendedTableView.delegate = self
        recommendedTableView.dataSource = self
        recommendedTableView.alpha = 0
        
        setupViewElements()
    }
    
    private func setupViewElements() {
        for button in topPickStackView.arrangedSubviews {
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            (button as! CustomButton).imageView?.contentMode = .scaleAspectFit
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
            catalogueView.isHidden = true
        } else {
            topPicksViewHeightConstraint.constant = 126
            topPicksStackViewWidthConstraint.constant = UIScreen.main.bounds.width - 16
            topPickStackView.axis = .horizontal
            topPickStackView.distribution = .equalSpacing
            topPickStackView.spacing = 0
            recommendedTableView.alpha = 0
            catalogueView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.topPicksViewExpandButton.titleLabel?.text = self.isHorizontalStack ? "More" : "Close"
            if !self.isHorizontalStack {
                UIView.animate(withDuration: 0.3, animations: {
                    self.recommendedTableView.alpha = 1
                    
                })
            }
        }
    }
}

// MARK: - Collection View
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !scannedBeers.isEmpty else {
            collectionView.emptyMessageView(message: "No beers scanned! Try adding one from the button on the top right of this view.")
            return 0
        }
        return scannedBeers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 172, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beerCell", for: indexPath) as! BeerCollectionViewCell
        cell.formatCell(forBeer: scannedBeers[indexPath.row])
        return cell
    }
}

// MARK: - Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerRowCell", for: indexPath) as! BeerRowTableViewCell
        cell.formatCell()
        return cell
    }
}
