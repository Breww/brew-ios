//
//  AutocompleteFetcher.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct AutocompleteFetcher {
    static func getBeersFromNameQuery(_ query: String, completion: @escaping(_ coins: [Beer]?) -> Void) {
        let url = "https://us-central1-breww-220002.cloudfunctions.net/getAutoComplete?name=\(query)"
        var beers: [Beer] = []
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data)
                for subJson in json {
                    for hit in subJson.1 {
                        beers.append(Beer.init(
                            name: hit.1["name"].stringValue,
                            style: hit.1["style"].stringValue,
                            catagory: hit.1["category"].stringValue,
                            description: nil,
                            primaryImage: nil,
                            positiveRating: nil)
                        )
                    }
                }
                completion(beers)
            } else {
                completion(nil)
            }
        }
    }
}
