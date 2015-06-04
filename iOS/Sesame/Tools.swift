//
//  Tools.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 29/05/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import Foundation
import MapKit


//
//  CONSTANTS
//
let admin:Int = 1

//
//  COLORS
//
let pink = UIColor(red: 1.000, green: 0.282, blue: 0.514, alpha: 1.000)
let darkBlue = UIColor(red: 0.224, green: 0.247, blue: 0.345, alpha: 1.000)
let lightBlue = UIColor(red: 0.286, green: 0.314, blue: 0.435, alpha: 1.000)
let lightWhite = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1.000) /*#f9f9f9*/

public func dateFromString(date: String, format: String) -> NSDate {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = format
    if let date = dateFormatter.dateFromString(date) {
        return date
    } else {
        return NSDate(timeIntervalSince1970: 0)
    }
}

func dateFormatterFromJSToString(date : String) -> String{
    var dateFormater        = NSDateFormatter()
    dateFormater.dateFormat = "HH:mm"
    dateFormater.locale = NSLocale(localeIdentifier: "fr_FR")
    
    var lastOpen = dateFromString(date, "yyyy-MM-dd'T'HH:mm:ss.SSS'Z")
    
    return dateFormater.stringFromDate(lastOpen)
}

func showSimpleAlertWithTitle(title: String!, #message: String, #viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(action)
    viewController.presentViewController(alert, animated: true, completion: nil)
}

func zoomToUserLocationInMapView(mapView: MKMapView) {
    if let coordinate = mapView.userLocation.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        mapView.setRegion(region, animated: true)
    }
}

func makeCoordinate(lat:String, lng:String) -> CLLocationCoordinate2D{
    return CLLocationCoordinate2D(latitude: Double((lat as NSString).doubleValue), longitude: Double((lng as NSString).doubleValue))
}

func zoomToCoordinateInMapView(pin:Bool, title: String ,lat:String, lng:String, mapView : MKMapView){

    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double((lat as NSString).doubleValue), longitude: Double((lng as NSString).doubleValue))
    
    if(pin){
        var dropPin = MKPointAnnotation()
        dropPin.coordinate = location
        dropPin.title = title
        mapView.addAnnotation(dropPin)
    }

    let region = MKCoordinateRegionMakeWithDistance(location, 3000, 3000)
    mapView.setRegion(region, animated: false)
    
    
}



