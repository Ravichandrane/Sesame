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
import AudioToolbox


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //
    //  VARIABLE
    //
    
    let api = API(raspberryURL: "http://10.30.1.18:3000")
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
    @IBOutlet var button: UIButton!
    
    @IBOutlet var lock: LockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //  STATUS BAR & BACKGROUND
        //
        self.view.backgroundColor = darkBlue
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        navigationController?.navigationBar.barTintColor = lightBlue
        navigationController?.navigationBar.tintColor = pink
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        //
        //  MANAGE HOME BTN
        //
        self.manageHome.backgroundColor = lightWhite
        self.manageHome.setTitleColor(pink, forState: UIControlState.Normal)
        
        //
        //  LOGGING AUTHENTIFICATION
        //
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var currentUser = PFUser.currentUser()

        if(!defaults.boolForKey("isANewUser"))
        {
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("OnBoard") as? OnBoardViewController {
                self.presentViewController(pageViewController, animated: false, completion: nil)
            }
        }else if currentUser == nil {
            self.performSegueWithIdentifier("goToLogin", sender: self)
        }
        
        //
        //  VIEW CONTENT
        //
        initLocationManager()
        //Refresh data with a timer
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("showDoorStatus"), userInfo: nil, repeats: true)
        
        //Init gesture on the open button
        var _myTap: UITapGestureRecognizer?
        _myTap = UITapGestureRecognizer(target: self
            , action: Selector("actionButton:"))
        lock.addGestureRecognizer(_myTap!)
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
            
            //If opening
            animButton(responseObject["status"] as! Int, self.lock)
            
            let statusText = responseObject["status_text"] as! String
            let date = dateFormatterFromJSToString(responseObject["lastOpen"] as! String)
            let lastUser = responseObject["lastUser"] as? String == PFUser.currentUser()?.objectForKey("userfirstname") as? String ?"vous même":responseObject["lastUser"] as! String
            
            if(responseObject["lastUser"] as! String != ""){
                self.lastOpen.text = "à \(date) par \(lastUser)"
            }else{
                self.lastOpen.text = "à \(date)"
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
            
            //Show the door status
            self.statusLabel.text = response["status_text"] as? String
            
            //Vibrate if response
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            //If opening
            if(response["status_code"] as! Int == 4){
                if let date = response["date"] as? String{
                    let date = dateFormatterFromJSToString(response["date"] as! String)
                    self.lastOpen.text = "à \(date) par vous même"
                }
                
                
                var history = PFObject(className:"History")
                history["user"] = PFUser.currentUser()
                history.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {

                    } else {
                        // There was a problem, check error.description
                    }
                }
                
                
            }
            animButton(response["status_code"] as! Int, self.lock)
        }
        
    }
    
    
    
    
}

