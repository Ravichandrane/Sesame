//
//  ViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 28/05/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //
    //  VARIABLE
    //
    
    let api = API(raspberryURL: "http://raspberry.pierre-olivier.fr:3000")
    // Global variables
    lazy var manager: CLLocationManager! = {
        let  manager = CLLocationManager()
        return manager
        }()
    
    //
    //  OUTLET
    //
    
    @IBOutlet var manageHome: UIButton!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var lastOpen: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //  STATUS BAR & BACKGROUND
        //
        self.view.backgroundColor = darkBlue
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        navigationController!.navigationBar.barTintColor = lightBlue
        navigationController!.navigationBar.tintColor = pink
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        //
        //  MANAGE HOME BTN
        //
        self.manageHome.backgroundColor = lightWhite
        self.manageHome.setTitleColor(pink, forState: UIControlState.Normal)
        
        //
        //  LOGGING AUTHENTIFICATION
        //
        var currentUser = PFUser.currentUser()
        if currentUser == nil {
            self.performSegueWithIdentifier("GoToLoginController", sender:self)
        }
        
        //
        //  VIEW CONTENT
        //
        initLocationManager()
        var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("showDoorStatus"), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool){
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        navigationController!.navigationBar.barTintColor = lightBlue
        navigationController!.navigationBar.tintColor = pink
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.showDoorStatus()
    }
    
    //
    //  FUNCTIONS
    //
    
    func initLocationManager(){
        self.manager.delegate        = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter  = kCLDistanceFilterNone
        self.manager.requestAlwaysAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    func showDoorStatus(){
        api.getDoorStatus() { responseObject, error in
            let statusText = responseObject["status_text"] as! String
            let date = dateFormatterFromJSToString(responseObject["lastOpen"] as! String)
            let lastUser = responseObject["lastUser"] as! String
            
            if(responseObject["lastUser"] as! String != ""){
                self.lastOpen.text = "A \(date) par \(lastUser)"
            }else{
                self.lastOpen.text = "A \(date)"
            }
            self.statusLabel.text = statusText
        }
    }
    
    //
    //  ACTIONS
    //
    
    @IBAction func actionButton(sender: AnyObject) {
        
        api.toggleGarageDoor(self) { responseObject, error in
            var response : Dictionary<String, AnyObject> = responseObject["response"] as! Dictionary
            self.statusLabel.text = response["status_text"] as? String
            if(response["status_code"] as! Int == 4){
                let date = dateFormatterFromJSToString(response["date"] as! String)
                self.lastOpen.text = "A \(date) par vous même"
            }
        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("GoToLoginController", sender:self)
        
    }
    
    
    
    
}

