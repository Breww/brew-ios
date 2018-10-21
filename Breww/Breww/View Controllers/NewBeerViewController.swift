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
import FirebaseStorage
import FirebaseFirestore
import JGProgressHUD

class NewBeerViewController: UIViewController {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var scannedImageView: UIImageView!
    @IBOutlet weak var addImageStackView: UIStackView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var thumbsDownButton: UIButton!
    @IBOutlet weak var thumbsUpButton: UIButton!
    
    var nameCell: DetailsTableViewCell {
        return detailsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DetailsTableViewCell
    }
    var styleCell: DetailsTableViewCell {
        return detailsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! DetailsTableViewCell
    }
    var catagoryCell: DetailsTableViewCell {
        return detailsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DetailsTableViewCell
    }
    var descriptionCell: DetailsTableViewCell {
        return detailsTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! DetailsTableViewCell
    }

    var queriedBeers: [Beer] = []
    var imageURL: String?
    var selectedPositiveRating: Bool?
    
    let hud = JGProgressHUD(style: .dark)
    
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
        hud.textLabel.text = "Searching..."
        
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
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let beer = Beer(
            name: nameCell.searchField.text ?? "Unknown",
            style: styleCell.searchField.text ?? "Unknown",
            catagory: catagoryCell.searchField.text ?? "Unknown",
            description: descriptionCell.searchField.text,
            primaryImage: scannedImageView.image,
            positiveRating: selectedPositiveRating ?? true
        )
        
        let beerData = ["name": beer.name, "style": beer.style, "category": beer.catagory, "description": beer.description ?? "Unknown", "rating": beer.positiveRating! ? 1: 0, "imgURL": imageURL ?? ""] as [String : Any]
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Device.id())
        docRef.getDocument { (doc, err) in
            if let document = doc, document.exists {
                docRef.updateData(["beers" : FieldValue.arrayUnion([beerData])], completion: { (err) in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                docRef.setData(["beers": [beerData]], completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func ratingButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tintColor = UIColor(named: "RightGradient")
            thumbsUpButton.tintColor = .black
            selectedPositiveRating = false
        } else {
            sender.tintColor = UIColor(named: "PositiveColor")
            thumbsDownButton.tintColor = .black
            selectedPositiveRating = true
        }
    }
    
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        let cameraViewController = CameraViewController(allowsLibraryAccess: false, allowsSwapCameraOrientation: false) { [weak self] (image, asset) in
            if image != nil {
                if let strongSelf = self {
                    strongSelf.hud.show(in: strongSelf.view)
                }
                self?.addImageStackView.isHidden = true
                self?.scannedImageView.isHidden = false
                self?.scannedImageView.image = image
                self?.uploadImage(completion: { [weak self] url in
                    guard let url = url else { return }
                    self?.imageURL = url
                    BeerFromURLFetcher.getBeer(url: url, completion: { [weak self] beer in
                        if let strongSelf = self {
                            strongSelf.hud.dismiss()
                        }
                        guard let beer = beer else { return }
                        print(beer)
                        DispatchQueue.main.async {
                            self?.nameCell.searchField.text = beer.name
                            self?.styleCell.searchField.text = beer.style
                            self?.catagoryCell.searchField.text = beer.catagory
                            self?.descriptionCell.searchField.text = beer.description
                            self?.detailsTableView.reloadData()
                        }
                        
                    })
                })
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    func uploadImage(completion: @escaping (_ url: String?) -> Void) {
        guard let image = scannedImageView.image else { return }
        let imageID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageID).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error ?? "error")
                    completion(nil)
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    completion(url?.absoluteString)
                })
            }
        }
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
                    cell.searchField.text = selectedBeer.name
                    self.styleCell.searchField.text = selectedBeer.style
                    self.catagoryCell.searchField.text = selectedBeer.catagory
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
}
