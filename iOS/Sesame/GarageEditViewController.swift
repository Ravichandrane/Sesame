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
import SwiftLoader


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
    @IBOutlet var cellMapView: UITableViewCell!
    @IBOutlet var code: UITextField!
    @IBOutlet var radius: UITextField!
    @IBOutlet var cellRadius: UITableViewCell!
    @IBOutlet var nom: UITextField!
    @IBOutlet var cellName: UITableViewCell!
    @IBOutlet var virtualPerimeter: UISwitch!
    @IBOutlet var cellIArrive: UITableViewCell!
    @IBOutlet var cellIgoing: UITableViewCell!
    @IBOutlet var cellRayon: UITableViewCell!

    @IBOutlet var enterSwitch: UISwitch!
    @IBOutlet var exitSwitch: UISwitch!
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
        SwiftLoader.show(animated: true)
        
        isAdmin(PFUser.currentUser()!){ rank in
            self.cellRayon.userInteractionEnabled = true
            self.cellMapView.userInteractionEnabled = true
            self.cellName.userInteractionEnabled = true
        }

        self.mapView.showsUserLocation = true
        getGarageInfos()
        let defaults = NSUserDefaults.standardUserDefaults()
        if(!defaults.boolForKey("virtualPerimeter"))
        {
            self.virtualPerimeter.setOn(false, animated: false)
            self.cellIArrive.hidden = true
            self.cellIgoing.hidden = true
            self.cellRayon.hidden = true
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //
    //  FUNCTION
    //
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.virtualPerimeter.on == false {
            
            if indexPath.section == 0 && indexPath.row == 2{
                return 0.0
            }
            
            if indexPath.section == 2 && indexPath.row == 1{
                return 0.0
            }
            
            if indexPath.section == 2 && indexPath.row == 2{
                return 0.0
            }
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            return 190.0
        }
        
        
        
        return 44.0
    }
    
    // Recupérer les données du garage
    func getGarageInfos(){
        
        var profil : PFObject = PFUser.currentUser()!.objectForKey("home") as! PFObject
        var query = PFQuery(className:"Homes")
        query.getObjectInBackgroundWithId(profil.objectId!) {
            (profil: PFObject?, error: NSError?) -> Void in
            if error == nil && profil != nil {                
                self.garageId = profil?.objectId
                
                var radius:Int = profil!.objectForKey("radius") as! Int
                
                self.code.text = profil?.objectId
                self.nom.text = profil?.objectForKey("name") as! String
                self.radius.text = "\(radius)"
                
                zoomToCoordinateInMapView(false,false,profil?.objectForKey("name") as! String, profil?.objectForKey("lat") as! String, profil?.objectForKey("long") as! String, self.mapView)
                
                SwiftLoader.hide()

                
            }
        }
        
    
    }

    
    // Mettre à jour les données du garage
    func updateGarageDetails(){
        
        SwiftLoader.show(animated: true)
        
        if(self.virtualPerimeter.on){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "virtualPerimeter")
        }else{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "virtualPerimeter")
        }
        
        if(self.enterSwitch.on){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "virtualPerimeterEnter")
        }else{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "virtualPerimeterEnter")
        }
        
        if(self.exitSwitch.on){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "virtualPerimeterEnter")
        }else{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "virtualPerimeterEnter")
        }

        
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
                    SwiftLoader.hide()
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
    
    @IBAction func showUserLocation(sender: AnyObject) {
        zoomToUserLocationInMapView(self.mapView)
    }
    @IBAction func virtualPerimeter(sender: UISwitch) {
        self.tableView.reloadData()
        
        if(sender.on){
            self.cellIArrive.hidden = false
            self.cellIgoing.hidden = false
            self.cellRayon.hidden = false
        }else{
            self.cellIArrive.hidden = true
            self.cellIgoing.hidden = true
            self.cellRayon.hidden = true
        }
    }
    
    @IBAction func enterRegion(sender: UISwitch) {
        if(!sender.on && !self.exitSwitch.on){
            self.exitSwitch.setOn(true, animated: true)
        }
    }
    
    @IBAction func exitRegion(sender: UISwitch) {
        if(!sender.on && !self.enterSwitch.on){
            self.enterSwitch.setOn(true, animated: true)
        }
    }
    @IBAction func logout(sender: AnyObject) {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
