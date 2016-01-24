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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var location: UILabel!
    var currentLocation = CLLocation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        location.text = chosenBusiness.name
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
    }
    
    func setup() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        addPin()
        getDirections()
        
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
    
        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
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
    
    func getDirections() {
        var request: MKDirectionsRequest = MKDirectionsRequest()
        let destination = placemark(chosenBusiness.latitude, longitude: chosenBusiness.longitude)
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = destination
        request.transportType = MKDirectionsTransportType.Any
        request.requestsAlternateRoutes = true
        
        var directions: MKDirections = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler() {
            (response, error) in
            if(error == nil && response != nil) {
                for route in response!.routes {
                    var r: MKRoute = route as! MKRoute
                    self.mapView.addOverlay(r.polyline, level: MKOverlayLevel.AboveRoads)
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        print("redenrerForOverlay")
        if(overlay.isKindOfClass(MKPolyline)) {
            var renderer: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.greenColor()
            renderer.lineWidth = 5
            return renderer
        }
        return nil
    }
    
//    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayView! {
//        print("ViewForOverlay")
//        if (overlay.isKindOfClass(MKPolyline)) {
//            let lineView: MKPolylineView = MKPolylineView(overlay: overlay)
//            lineView.backgroundColor = UIColor.greenColor()
//            
//            return lineView;
//        }
//        return nil;
//    }
    
    
}
