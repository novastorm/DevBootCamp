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
    var distance = ""
    var latitude = ""
    var longitude = ""
    var address = ""
    var city = ""
    var coordinate = [String:String]()
    var phone = 0
    var image_url = ""
    var is_closed = ""
    var rating = 0
    var categories = ""
    
    
    static var business = [Business]()
    
    
    // MARK: Initializers
    
    init(dictionary: [String : AnyObject]) {
        
        name = dictionary["name"] as! String
        distance = dictionary["distance"] as! String
//        latitude = dictionary["latitude"] as! String
//        longitude = dictionary["longitude"] as! String
        address = dictionary["address"] as! String
        city = dictionary["city"] as! String
        coordinate = dictionary["coordinate"] as! [String:String]
        phone = dictionary["phone"] as! Int
        image_url = dictionary["image_url"] as! String
        is_closed = dictionary["is_closed"] as! String
        rating = dictionary["rating"] as! Int
        categories = dictionary["categories"] as! String
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
