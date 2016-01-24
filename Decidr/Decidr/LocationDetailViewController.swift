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

class LocationDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    var latitude: Double!
    var longitude: Double!
    var businessResults = [Business]()
    var chosenBusiness: Business!
    let regionRadius: CLLocationDistance = 20000
    let locationManager = CLLocationManager()
    var destination: MKMapItem!
    
    @IBOutlet weak var firstLineLabel: UILabel!
    
    @IBOutlet weak var walkingTimeLabel: UILabel!
    @IBOutlet weak var transitTimeLabel: UILabel!
    @IBOutlet weak var carTravelTime: UILabel!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var location: UILabel!
    var currentLocation = CLLocation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func walkingDirections(sender: UIButton) {
        print("getting walking directions")
    }
    
    @IBAction func transitDirections(sender: UIButton) {
        print("geting transit directions")
    }
    
    @IBAction func carDirections(sender: UIButton) {
        print("geting car directions")
    }
    
    func setup() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        addPin()
        getWalkingDirections()
        getCarDirections()
        getTransitDirections()
        location.text = chosenBusiness.name
        firstLineLabel.text = chosenBusiness.address
    }
    
    func addPin() {
        let location = CLLocationCoordinate2D(
            latitude: chosenBusiness.latitude,
            longitude: chosenBusiness.longitude
            )
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = chosenBusiness.name
        annotation.subtitle = "\(chosenBusiness.distance) m"
        mapView.addAnnotation(annotation)
        }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = calculateMidPoint(location)
        let region = MKCoordinateRegionMake(center, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func calculateMidPoint(location: CLLocation) -> CLLocationCoordinate2D {
        let ourLat = location.coordinate.latitude
        let ourLong = location.coordinate.longitude
        
        let barLat = chosenBusiness.latitude
        let barLong = chosenBusiness.longitude
        
        let midLat = (ourLat + barLat) / 2.0
        let midLong = (ourLong + barLong) / 2.0
        
        let coordinate = CLLocationCoordinate2D(latitude: midLat, longitude: midLong)
        return coordinate
        
    }
    
    func placemark(latitude: Double, longitude: Double) -> MKMapItem {
        let coords = CLLocationCoordinate2DMake(latitude, longitude)
        
        let address = [String:AnyObject]()
        
        let place = MKPlacemark(coordinate: coords, addressDictionary: address)
        
        let mapItem = MKMapItem(placemark: place)
        return mapItem
    }
    
    func getWalkingDirections() {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        let destination = placemark(chosenBusiness.latitude, longitude: chosenBusiness.longitude)
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = destination
        request.transportType = MKDirectionsTransportType.Walking
        request.requestsAlternateRoutes = true
        
        let directions: MKDirections = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler() {
            (response, error) in
            if(error == nil && response != nil) {
                for route in response!.routes {
                    print(route.transportType)
                    print(route.expectedTravelTime)
                    dispatch_async(dispatch_get_main_queue(), {
                    let r: MKRoute = route
                    self.mapView.addOverlay(r.polyline, level: MKOverlayLevel.AboveRoads)
                    self.walkingTimeLabel.text = String(route.expectedTravelTime)
                    })
                }
            }
        }
    }
    
    func getTransitDirections() {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        let destination = placemark(chosenBusiness.latitude, longitude: chosenBusiness.longitude)
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = destination
        request.transportType = MKDirectionsTransportType.Transit
        request.requestsAlternateRoutes = false
        
        let directions: MKDirections = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler() {
            (response, error) in
            if(error == nil && response != nil) {
                for route in response!.routes {
                    print(route.transportType)
                    print(route.expectedTravelTime)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.transitTimeLabel.text = String(route.expectedTravelTime)
                    })

                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.transitTimeLabel.text = "- -"
                })
            }
        }
    }
    
    func getCarDirections() {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        let destination = placemark(chosenBusiness.latitude, longitude: chosenBusiness.longitude)
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = destination
        request.transportType = MKDirectionsTransportType.Automobile
        request.requestsAlternateRoutes = false
        
        let directions: MKDirections = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler() {
            (response, error) in
            if(error == nil && response != nil) {
                for route in response!.routes {
                    print(route.transportType)
                    print(route.expectedTravelTime)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.carTravelTime.text = String(route.expectedTravelTime)
                    })
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        print("redenrerForOverlay")
        if(overlay.isKindOfClass(MKPolyline)) {
            let renderer: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.greenColor()
            renderer.lineWidth = 5
            return renderer
        }
        return nil
    }
}
