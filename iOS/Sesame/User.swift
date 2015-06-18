//
//  User.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 03/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import Foundation
import Parse

func isAdmin(user:PFUser, completionHandler : (Bool) -> ()) {
    
    var rank_id:Int = -1
    
    if(user.objectForKey("profil") != nil){
        var profil : PFObject = user.objectForKey("profil") as! PFObject
        var query = PFQuery(className:"NewProfil")
        query.getObjectInBackgroundWithId(profil.objectId!) {
            (profil: PFObject?, error: NSError?) -> Void in
            if error == nil && profil != nil {
                rank_id = profil!.objectForKey("rank_id") as! Int
                if(rank_id == 1){
                    completionHandler(true)
                }
            }
        }
    }
}

func getProfil(user:PFObject, completionHandler : (String) -> ()) {
    
    var rank:String = ""

    if(user.objectForKey("profil") != nil){
        
        var profil : PFObject = user.objectForKey("profil") as! PFObject
        var query = PFQuery(className:"NewProfil")
        query.getObjectInBackgroundWithId(profil.objectId!) {
            (profil: PFObject?, error: NSError?) -> Void in
            if error == nil && profil != nil {
                rank = profil!.objectForKey("rank") as! String
                completionHandler(rank)
            }
        }
    }
}