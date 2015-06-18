 //
//  AppDelegate.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 28/05/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import Parse
import Bolts
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager() // Add this statement


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("d5nDyqrsIam1tkgHSEv1TB3mNDFBLVV0qOv6Gon4",
            clientKey: "Vh6bATHzAzkxR6r3PXWJlNXkcfOjQRKKfPChZecN")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: nil))
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        return true
    }
    
    func handleRegionEvent() {
        let api = API(raspberryURL: "http://raspberry.pierre-olivier.fr:3000")
        api.openGarageDoor(nil){ responseObject, error in
            var response : Dictionary<String, AnyObject> = responseObject["response"] as! Dictionary
            // Show an alert if application is active
            if UIApplication.sharedApplication().applicationState == .Active {
                if let viewController = self.window?.rootViewController {
                    showSimpleAlertWithTitle(nil, message: (response["status_text"] as? String)!, viewController: viewController)
                }
            } else {
                // Otherwise present a local notification
                var notification = UILocalNotification()
                notification.alertBody = response["status_text"] as? String
                notification.soundName = "Default";
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if region is CLCircularRegion {
            let defaults = NSUserDefaults.standardUserDefaults()
            if(defaults.boolForKey("virtualPerimeterEnter"))
            {
                handleRegionEvent()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if region is CLCircularRegion {
            let defaults = NSUserDefaults.standardUserDefaults()
            if(defaults.boolForKey("virtualPerimeterExit"))
            {
                handleRegionEvent()
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

