//
//  Device.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation

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
