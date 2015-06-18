//
//  MapViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 10/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var home:Geotification?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //  STATUS BAR & BACKGROUND
        //
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        navigationController!.navigationBar.barTintColor = lightWhite
        navigationController!.navigationBar.tintColor = pink
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:darkBlue]
        
        mapView.showsUserLocation = true
        self.mapView.delegate = self;
        
        if let homme = self.home {
            let annotation = MKPointAnnotation()
            annotation.title = home?.note
            annotation.coordinate = home!.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            self.title = home?.note
        
            //If virtual perimeter active add the overlay
            let defaults = NSUserDefaults.standardUserDefaults()
            if(defaults.boolForKey("virtualPerimeter"))
            {
                self.addRadiusOverlayForGeotification(self.home!)
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = pink
            circleRenderer.fillColor = pink.colorWithAlphaComponent(0.4)
            return circleRenderer
        }
        return nil
    }
    
    func addRadiusOverlayForGeotification(geotification: Geotification) {
        mapView?.addOverlay(MKCircle(centerCoordinate: geotification.coordinate, radius: geotification.radius))
    }
    
    
    //Exit from the view
    @IBAction func exit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {}); 
    }

}
