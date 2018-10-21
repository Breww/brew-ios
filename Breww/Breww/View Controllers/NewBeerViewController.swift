//
//  NewBeerViewController.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit
import ALCameraViewController
import SearchTextField

class NewBeerViewController: UIViewController {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var scannedImageView: UIImageView!
    @IBOutlet weak var addImageStackView: UIStackView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var queriedBeers: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupUIElements()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    private func setupUIElements() {
        scannedImageView.isHidden = true
        
        addImageButton.imageView?.contentMode = .scaleAspectFit
        addImageButton.layer.borderColor = UIColor.darkGray.cgColor
        addImageButton.layer.borderWidth = 2
        addImageButton.layer.cornerRadius = addImageButton.bounds.width / 2
        
        imageContainerView.layer.masksToBounds = false
        imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageContainerView.layer.shadowRadius = 1
        imageContainerView.layer.shadowOpacity = 0.2
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        let cameraViewController = CameraViewController(allowsLibraryAccess: false, allowsSwapCameraOrientation: false) { [weak self] (image, asset) in
            if image != nil {
                self?.addImageStackView.isHidden = true
                self?.scannedImageView.isHidden = false
                self?.scannedImageView.image = image
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
}

extension NewBeerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "Name"
            cell.searchField.userStoppedTypingHandler = {
                guard let text = cell.searchField.text else { return }
                
                cell.searchField.showLoadingIndicator()
                AutocompleteFetcher.getBeersFromNameQuery(text) { beers in
                    guard let beers = beers else { return }
                    
                    self.queriedBeers = beers
                    cell.searchField.filterStrings(self.queriedBeers.map { $0.name })
                    cell.searchField.stopLoadingIndicator()
                }
            }
            cell.searchField.maxNumberOfResults = 5
            
            cell.searchField.itemSelectionHandler = { [weak self] name, itemPosition in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    let selectedBeer = self.queriedBeers[itemPosition]
                    let styleCell = self.detailsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! DetailsTableViewCell
                    let catagoryCell = self.detailsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DetailsTableViewCell
                    cell.searchField.text = selectedBeer.name
                    styleCell.searchField.text = selectedBeer.style
                    catagoryCell.searchField.text = selectedBeer.catagory
                }
                
            }
            cell.searchField.placeholder = "Enter the beer's name"
        case 1:
            cell.nameLabel.text = "Style"
            cell.searchField.placeholder = "Enter the beer's style (i.e. Irish Ale)"
        case 2:
            cell.nameLabel.text = "Catagory"
            cell.searchField.placeholder = "Enter the beer's catagory (i.e. Lager)"
        case 3:
            cell.nameLabel.text = "Description"
            cell.searchField.placeholder = "Enter a description for the beer"
        default:
            break
        }
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        AutocompleteFetcher.getBeersFromNameQuery(text) { beers in
            guard let beers = beers else { return }
            
            self.queriedBeers = beers
            self.detailsTableView.reloadData()
            
            let cell = self.detailsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DetailsTableViewCell
            cell.searchField.becomeFirstResponder()
        }
        
        print(text)
    }
}
