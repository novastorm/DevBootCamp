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
    
    @IBOutlet weak var location: UILabel!
    var currentLocation = CLLocation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        location.text = "\(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)"
    }
    
}
