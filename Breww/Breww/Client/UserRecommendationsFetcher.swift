//
//  UserRecommendationsFetcher.swift
//  Breww
//
//  Created by Mat Schmid on 2018-10-20.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct UserRecommendationsFetcher {
    static func getUserRecommendations(completion: @escaping(_ coins: [Beer]?) -> Void) {
        let id = Device.id()
        let url = "https://us-central1-breww-220002.cloudfunctions.net/recommendPersonal?uuid=\(id)"
        var beers: [Beer] = []
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data)
                for sub in json {
                    for dex in sub.1 {
                        let beer = Beer.init(
                            name: dex.1["name"].stringValue,
                            style: dex.1["style"].stringValue,
                            catagory: dex.1["catagory"].stringValue,
                            description: dex.1["description"].stringValue,
                            primaryImage: nil,
                            positiveRating: nil
                        )
                        beers.append(beer)
                    }
                }
                completion(beers)
            } else {
                completion(nil)
            }
        }
    }
    
    static func imageFromBrand(brand: String, completion: @escaping(_ coins: String?) -> Void ) {
        let url = "https://us-central1-breww-220002.cloudfunctions.net/getBeerImage?brand=\(brand.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        print(url)
        Alamofire.request(url).responseString { (res) in
            print(res)
            completion(res.value!)
        }
    }
}
