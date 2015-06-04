//
//  GarageEditViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 04/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import Parse
import MapKit

protocol GarageProfilEditedDelegate{
    func garageProfileEdited(added:Bool)
}

class GarageEditViewController: UITableViewController {
    
    
    //
    //  VARIABLES
    //
    
    var delegate:GarageProfilEditedDelegate?
    var garageId:String!

    
    //
    //  OUTLETS
    //
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var code: UITextField!
    @IBOutlet var long: UITextField!
    @IBOutlet var lat: UITextField!
    @IBOutlet var radius: UITextField!
    @IBOutlet var nom: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        self.mapView.showsUserLocation = true
        getGarageInfos()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //
    //  FUNCTION
    //
    
    // Recupérer les données du garage
    func getGarageInfos(){
        
        var profil : PFObject = PFUser.currentUser()!.objectForKey("home") as! PFObject
        var query = PFQuery(className:"Homes")
        query.getObjectInBackgroundWithId(profil.objectId!) {
            (profil: PFObject?, error: NSError?) -> Void in
            if error == nil && profil != nil {
                println(profil)
                
                self.garageId = profil?.objectId
                
                var radius:Int = profil!.objectForKey("radius") as! Int
                
                self.code.text = profil?.objectId
                self.nom.text = profil?.objectForKey("name") as! String
                self.radius.text = "\(radius)"
                self.lat.text = profil?.objectForKey("lat") as! String
                self.long.text = profil?.objectForKey("long") as! String
                
                zoomToCoordinateInMapView(false,profil?.objectForKey("name") as! String, profil?.objectForKey("lat") as! String, profil?.objectForKey("long") as! String, self.mapView)
                
            }
        }
        
    
    }

    
    // Mettre à jour les données du garage
    func updateGarageDetails(){
        
        var query = PFQuery(className:"Homes")
        query.getObjectInBackgroundWithId(self.garageId) {
            (garage: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let garage = garage {
                
                var locValue:CLLocationCoordinate2D = self.mapView.centerCoordinate
                
                garage["name"] = self.nom.text
                garage["lat"] = "\(locValue.latitude)"
                garage["long"] = "\(locValue.longitude)"
                garage["radius"] = (self.radius.text as NSString).doubleValue
                garage.saveInBackground()
                
                if let deleg = self.delegate
                {
                    deleg.garageProfileEdited(true)
                }
            }
        }
    
    }
    
    
    //
    //  ACTIONS
    //
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }

    @IBAction func save(sender: AnyObject) {
        updateGarageDetails()
    }
}
