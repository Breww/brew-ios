//
//  NewBeerViewController.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit
import ALCameraViewController

class NewBeerViewController: UIViewController {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var scannedImageView: UIImageView!
    @IBOutlet weak var addImageStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
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
