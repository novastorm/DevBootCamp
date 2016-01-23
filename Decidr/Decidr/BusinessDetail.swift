//
//  BusinessDetail.swift
//  Decidr
//
//  Created by Andrew Marmion on 1/23/16.
//  Copyright © 2016 Andrew Marmion. All rights reserved.
//

import Foundation
import UIKit
// MARK: - Users

struct Business {
    
    // MARK: Properties
    
    var name = ""
    var distance = 0.0
    var latitude = 0.0
    var longitude = 0.0
    var address:String!
    var city = ""
    var phone = ""
    var image_url = ""
    var is_closed = false
    var rating = 0
    var categories = [String]()
    
    
    static var businessData = [Business]()
    
    
    // MARK: Initializers
    
    init(dictionary: [String : AnyObject]) {
        
        name = dictionary["name"] as! String
        distance = dictionary["distance"] as! Double
        let location = dictionary["location"]
        address = location!["address"]!![0] as! String
        city = location!["city"] as! String
        let coordinate = location!["coordinate"]
        latitude = coordinate!!["latitude"] as! Double
        longitude = coordinate!!["longitude"] as! Double
        image_url = dictionary["image_url"] as! String
        is_closed = dictionary["is_closed"] as! Bool
        rating = dictionary["rating"] as! Int
//        categories = dictionary["categories"] as! Array
    }
    
    static func usersFromResults(results: [[String : AnyObject]]) -> [Business] {
        
        var businessList = [Business]()
        
        /* Iterate through array of dictionaries; each User is a dictionary */
        for result in results {
            businessList.append(Business(dictionary: result))
        }
        
        return businessList
    }
    
}
