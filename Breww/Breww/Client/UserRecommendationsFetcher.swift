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
        print("#########################################################")
        let id = Device.id()
        let url = "https://us-central1-breww-220002.cloudfunctions.net/recommendPersonal?uuid=\(id)"
        print(url)
        var beers: [Beer] = []
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let json = JSON(data)
                print(json)
            }
        }
    }
}
