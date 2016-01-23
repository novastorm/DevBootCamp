//
//  LocationDetailView.swift
//  Decidr
//
//  Created by Andrew Marmion on 1/23/16.
//  Copyright © 2016 Andrew Marmion. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class LocationDetailViewController: UIViewController
{
    
    let apiConsoleInfo = YelpAPIConsole()
    let client = YelpAPIClient()
    var latitude: String!
    var longitude: String!
    var coordinates: String!
    
    @IBOutlet weak var location: UILabel!
    var currentLocation = CLLocation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        latitude = String(currentLocation.coordinate.latitude)
        longitude = String(currentLocation.coordinate.longitude)
        location.text = "\(latitude) \(longitude)"
        print("latitude after segue \(latitude)")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getBars()
        
    }
    
    
    func getBars() {
        client.searchPlacesWithParameters(["ll": "\(latitude),\(longitude)", "category_filter": "bars", "radius_filter": "1000", "sort": "2", "limit": "1"], successSearch: { (data, response) -> Void in
            
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON \(data)")
            }
            guard let results = parsedResult["businesses"] as? NSArray else {
                print("Could nor find key businessess")
                return
            }
            
            print(results)
            Business.businessData = Business.usersFromResults(results as! [[String : AnyObject]])
            
            print(Business.businessData.count)
            for business in results {
                print(business["name"]!!)
            }
            
            }) { (error) -> Void in
                print(error)
        }
        
    }
}
