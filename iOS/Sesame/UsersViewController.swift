//
//  UserViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 02/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation
import SwiftLoader

class CustomCell:  UITableViewCell {
    //
    //  OUTLET
    //
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profil: UILabel!
    
    func showCell(cellDataParse : PFObject){
        
        if(cellDataParse.objectForKey("profil") != nil){
        
            getProfil(cellDataParse){ rank in
                self.profil.text = rank
                if(rank != "Propriétaire"){
                    self.selectionStyle = .None
                }
            }
            
        }else{
            self.profil.text = "(Pas de profil enregistré)"
        }
        
        let firstname  = cellDataParse.objectForKey("userfirstname") as! String
        var lastname  = cellDataParse.objectForKey("userlastname") as! String
        
        if(PFUser.currentUser()?.objectId == cellDataParse.objectId){
            lastname = lastname + " (vous)"
        }
        
        self.username.text = "\(firstname) \(lastname)"
        
    }
    
}

class UsersViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate, GarageProfilEditedDelegate {
    
    //
    //  VARIABLE
    //
    
    let locationManager = CLLocationManager() // Add this statement
    var refreshhControl:UIRefreshControl!
    
    var home:Geotification?

    
    //
    //  OUTLET
    //
    
    @IBOutlet var addUser: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    var dataParse:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        SwiftLoader.show(animated: true)
        
        //
        //  STATUS BAR & BACKGROUND
        //
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        navigationController!.navigationBar.barTintColor = lightWhite
        navigationController!.navigationBar.tintColor = pink
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:darkBlue]
        
        //
        //  CONTENT
        //
        
        getInfos()
        addUsers(nil)
        mapView.showsUserLocation = true
        locationManager.delegate = self
        self.mapView.delegate = self;
        
        self.refreshhControl = UIRefreshControl()
        self.refreshhControl.addTarget(self, action: "addUsers:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshhControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    //  FUNCTIONS
    //
    
    func getInfos(){
            
        var home:PFObject  = PFUser.currentUser()!.objectForKey("home") as! PFObject
        var query = PFQuery(className:"Homes")
        query.getObjectInBackgroundWithId(home.objectId!) {
            (profil: PFObject?, error: NSError?) -> Void in
            if error == nil && profil != nil {
                
                zoomToCoordinateInMapView(true, false,profil?.objectForKey("name") as! String, profil?.objectForKey("lat") as! String, profil?.objectForKey("long")as! String,self.mapView)
                
                let radius:Double = profil?.objectForKey("radius") as! Double
                
                self.home = Geotification(coordinate: makeCoordinate(profil?.objectForKey("lat") as! String, profil?.objectForKey("long")as! String), radius: radius, identifier: "100" , note: profil?.objectForKey("name") as! String)
                
                let defaults = NSUserDefaults.standardUserDefaults()
                if(defaults.boolForKey("virtualPerimeter"))
                {
                    self.startMonitoringGeotification(self.home!)
                    self.addRadiusOverlayForGeotification(self.home!)
                }else{
                    self.locationManager.stopMonitoringForRegion(self.regionWithGeotification(self.home!))
                }
                
            }
            
            if let error = error {
                let errorString = error.userInfo?["error"] as? String
                showSimpleAlertWithTitle("Error", message: errorString!, viewController: self)
            }
        }
    
    }
    
    func addUsers(sender:AnyObject?) {
        
        self.dataParse.removeAllObjects()
        
        var query = PFQuery(className: "_User")
        
        query.whereKey("home", equalTo: PFUser.currentUser()!.objectForKey("home")!);

        query.findObjectsInBackgroundWithBlock({
            (success:[AnyObject]?, error: NSError?) -> Void in
            
            if let objects = success as? [PFObject] {
                for object in objects {
                    self.dataParse.addObject(object)
                }
            }
            
            self.tableView.reloadData()
            
            SwiftLoader.hide()

            if(sender != nil){
                self.refreshhControl?.endRefreshing()
            }
        })
    }
    
    // MARK - TABLE VIEW
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataParse.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("cell") as! CustomCell
        let cellDataParse:PFObject = self.dataParse.objectAtIndex(indexPath.row) as! PFObject
        cell.showCell(cellDataParse)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let index = tableView.indexPathForSelectedRow()
        
        if segue.identifier == "showDetails" {

            let cellDataParse:PFObject = self.dataParse.objectAtIndex(index!.row) as! PFObject
            let vc = segue.destinationViewController as! UserDetailsViewController
            vc.user = cellDataParse
        }
        
        if segue.identifier == "garageEdit" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let addEventViewController = nav.topViewController as! GarageEditViewController
            addEventViewController.delegate = self
        }
        
        if segue.identifier == "showMap" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let addEventViewController = nav.topViewController as! MapViewController
            addEventViewController.home = self.home
        }
        
    }
    
    // MARK: - GEOTIFICATION
    
    func startMonitoringGeotification(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self)
        }
        // 3
        let region = regionWithGeotification(geotification)
        // 4
        locationManager.startMonitoringForRegion(region)
    }
    
    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .OnEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("Monitoring failed for region with identifier: \(region.identifier)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Location Manager failed with the following error: \(error)")
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
    
    
    //
    //  DELEGATE
    //
    
    func garageProfileEdited(edited:Bool){
        if(edited){
            self.dismissViewControllerAnimated(true, completion: nil)
            let annotationsToRemove = mapView.annotations.filter { $0 !== self.mapView.userLocation }
            mapView.removeAnnotations( annotationsToRemove )
            var overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            getInfos()
        }
    }

}
