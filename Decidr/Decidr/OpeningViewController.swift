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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    @IBAction func getVenue(sender: AnyObject) {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LocationDetailViewController") as! LocationDetailViewController
        controller.currentLocation = currentLocation
        self.navigationController!.pushViewController(controller, animated: true)
    }


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!
        print("Update")
        print(currentLocation.coordinate.latitude)
        print(currentLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
        
//        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LocationDetailViewController") as! LocationDetailViewController
//        controller.currentLocation = currentLocation
//        self.navigationController!.pushViewController(controller, animated: true)

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
}

