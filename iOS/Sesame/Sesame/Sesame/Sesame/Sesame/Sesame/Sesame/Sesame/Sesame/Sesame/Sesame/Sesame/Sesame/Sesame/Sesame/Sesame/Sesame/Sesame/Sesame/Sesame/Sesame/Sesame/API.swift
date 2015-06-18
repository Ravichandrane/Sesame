//
//  API.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 29/05/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import Foundation
import Alamofire
import Parse

class API {
    
    private let raspberryURL:String!
    
    init(raspberryURL:String){
        self.raspberryURL = raspberryURL
    }
    
    func getRaspberryURL() -> String{
        return self.raspberryURL
    }
    
    func getDoorStatus(completionHandler: (responseObject:Dictionary<String, AnyObject>, error: NSError?) -> ()){
        makeGETCall("garage/status", completionHandler: completionHandler)

    }
    
    func openGarageDoor(view: UIViewController?, completionHandler: (responseObject:Dictionary<String, AnyObject>, error: NSError?) -> ()) {
        makePOSTCall(view, section:"garage/open", completionHandler: completionHandler)
    }
    
    func closeGarageDoor(view: UIViewController, completionHandler: (responseObject:Dictionary<String, AnyObject>, error: NSError?) -> ()) {
        makePOSTCall(view, section:"garage/close", completionHandler: completionHandler)
    }
    
    func toggleGarageDoor(view: UIViewController, completionHandler: (responseObject:Dictionary<String, AnyObject>, error: NSError?) -> ()) {
        makePOSTCall(view, section:"garage/toggle", completionHandler: completionHandler)
    }
    
    func makeGETCall(section: String, completionHandler: (responseObject:Dictionary<String, AnyObject>, error: NSError?) -> ()) {
        Alamofire.request(.GET, "\(self.raspberryURL)/\(section)")
            .responseJSON { request, response, responseObject, error in
                if(response != nil){
                    completionHandler(responseObject: (responseObject as? Dictionary)!, error: error)
                }
        }
    }
    
    func makePOSTCall(view: UIViewController?, section: String, completionHandler: (responseObject:Dictionary<String, AnyObject>, error: NSError?) -> ()) {
        
        var user = PFUser.currentUser()
        var userID:String = user?.objectForKey("userfirstname") as! String
        let params = ["authenticate":userID]
        
        Alamofire.request(.POST, "\(self.raspberryURL)/\(section)", parameters: params)
            .responseJSON { request, response, responseObject, error in
                if((response) != nil){
                    completionHandler(responseObject: (responseObject as? Dictionary)!, error: error)
                }else{
                    if let viewController = view {
                        showSimpleAlertWithTitle("Problème de connexion", message: "Impossible de se connecter au serveur", viewController: view!)
                    }
                }
        }
    }
    
}