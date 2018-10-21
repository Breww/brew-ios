//
//  BeerFromURLFetcher.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct BeerFromURLFetcher {
    static func getBeer(url: String, completion: @escaping(_ coins: Beer?) -> Void) {
        let url = "https://us-central1-breww-220002.cloudfunctions.net/ocr?url=\(url)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data)
                for subJson in json {
                    for beer in subJson.1 {
                        let beeer = Beer.init(
                            name: beer.1["name"].stringValue,
                            style: beer.1["style"].stringValue,
                            catagory: beer.1["category"].stringValue,
                            description: beer.1["description"].stringValue,
                            primaryImage: nil,
                            positiveRating: nil
                        )
                        completion(beeer)
                    }
                }
            }
            completion(nil)
        }
    }
    
}
