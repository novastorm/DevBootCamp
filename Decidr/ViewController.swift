//
//  ViewController.swift
//  Yelp It Off Demo
//
//  Created by David Lechón Quiñones on 18/08/15.
//  Copyright (c) 2015 dlqapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let apiConsoleInfo = YelpAPIConsole()
    
    let client = YelpAPIClient()
    
    @IBAction func searchForBurgerPlaces() {
        client.searchPlacesWithParameters(["ll": "37.788022,-122.399797", "category_filter": "bars", "radius_filter": "100", "sort": "2", "limit": "1"], successSearch: { (data, response) -> Void in
            
            
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
            for business in results {
                print(business["name"]!!)
            }
            
        }) { (error) -> Void in
            print(error)
        }
        
    }
    
    @IBAction func getBusinessInfo() {
        client.getBusinessInformationOf("custom-burger-san-francisco", successSearch: { (data, response) -> Void in
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
        }) { (error) -> Void in
            print(error)
        }
        
    }
    
    @IBAction func searchTelephone() {
        client.searchBusinessWithPhone("+1-646-237-5035", successSearch: { (data, response) -> Void in
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
        }) { (error) -> Void in
            print(error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
}
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

