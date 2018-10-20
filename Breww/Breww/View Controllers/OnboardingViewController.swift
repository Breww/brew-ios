//
//  OnboardingViewController.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-19.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var catagoryCollectionView: UICollectionView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    let options = ["British Ale", "NA Ale", "German Ale", "Irish Ale", "NA Lager", "German Lager", "Belgian and French Ale", "Other"]
    var selectedOptions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        catagoryCollectionView.delegate = self
        catagoryCollectionView.dataSource = self
        getStartedButton.layer.cornerRadius = 6
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        print(selectedOptions)
        
        let db = Firestore.firestore()
        db.collection("users").document(Device.id()).setData([
            "preferredCategories": selectedOptions
        ]) { error in
            if error != nil {
                print(error.debugDescription)
            }
            
            let storyboard = UIStoryboard(name: "Core", bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "Core")
            
            self.present(rootViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = options[indexPath.row]
        let labelSize = name.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
        return CGSize(width: labelSize.width + 30, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath) as! SelectionCollectionViewCell
        cell.formatCell(name: options[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SelectionCollectionViewCell
        if selectedOptions.contains(options[indexPath.row]) {
            cell.labelView.layer.borderWidth = 2
            cell.labelView.layer.borderColor = UIColor.black.cgColor
            cell.nameLabel.textColor = .black
            
            selectedOptions = selectedOptions.filter { $0 != options[indexPath.row] }
        } else {
            cell.labelView.layer.borderWidth = 4
            cell.labelView.layer.borderColor = UIColor(named: "BlueButton")?.cgColor
            cell.nameLabel.textColor = UIColor(named: "BlueButton")
            
            selectedOptions.append(options[indexPath.row])
        }
    }

}
