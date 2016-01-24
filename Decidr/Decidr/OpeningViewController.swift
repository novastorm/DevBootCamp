//
//  OpeningViewController.swift
//  Decidr
//
//  Created by Andrew Marmion on 1/23/16.
//  Copyright © 2016 Andrew Marmion. All rights reserved.
//

import UIKit
import CoreLocation

class OpeningViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var beerButton: UIButton!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var latitude: String!
    var longitude: String!
    var businessResults = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.barStyle = .Black
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    @IBAction func getVenue(sender: AnyObject) {
        //show a progressview
        getBars { (success, data, error) -> Void in
            if success {
                if data.count > 0 {
//                    let businesses = data.shuffle()
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LocationDetailViewController") as! LocationDetailViewController
                    controller.currentLocation = self.currentLocation
//                    controller.chosenBusiness = businesses[0]
                    controller.businessResults = data
                    self.navigationController!.pushViewController(controller, animated: true)
                }
            }
        }
        
        
    }


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!
        print("Update")
        latitude = String(currentLocation.coordinate.latitude)
        longitude = String(currentLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
        

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func getBars(completionHandler: (success: Bool, data: [Business]! ,error: String?) -> Void) {
        YelpAPIClient().searchPlacesWithParameters(["ll": "\(latitude),\(longitude)", "category_filter": "bars", "radius_filter": "1000", "sort": "1", "limit": "10"], successSearch: { (data, response) -> Void in
            
            
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
            
            Business.businessData = Business.usersFromResults(results as! [[String : AnyObject]])

            completionHandler(success: true, data: Business.businessData ,error: nil)
            }) { (error) -> Void in
                print(error)
        }
        
    }
}

