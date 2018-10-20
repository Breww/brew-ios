//
//  Device.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import UIKit

struct Device {
    private static let kDeviceKey = "kDeviceKey"
    private static let defaults = UserDefaults.standard
    
    static func id() -> String {
        if let deviceID = defaults.value(forKey: kDeviceKey) {
            return deviceID as! String
        } else {
            let id = NSUUID().uuidString
            defaults.set(id, forKey: kDeviceKey)
            return id
        }
    }
    
    static func hasID() -> Bool {
        if let _ = defaults.value(forKey: kDeviceKey) {
            return true
        }
        return false
    }
}

extension UICollectionView {
    func emptyMessageView(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.sizeToFit()
        
        backgroundView = messageLabel
    }
    
    func restore() {
        backgroundView = nil
    }
}
