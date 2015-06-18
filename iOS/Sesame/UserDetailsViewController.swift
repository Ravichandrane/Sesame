//
//  UserDetailsViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 02/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UITableViewController {
    
    @IBOutlet var profil: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var login: UILabel!
    
    
    var user:PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name:String = user?.objectForKey("userlastname") as! String
        let firstname:String = user?.objectForKey("userfirstname") as! String
        self.firstName.text = "\(firstname) \(name)"
        self.login.text = user?.objectForKey("username") as? String
        
        self.title = firstname
        
        if(user!.objectForKey("profil") != nil){
            getProfil(user!){ rank in
                self.profil.text = rank
            }
        }else{
            self.profil.text = "(Pas de profil enregistré)"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let index = tableView.indexPathForSelectedRow()
        
        if segue.identifier == "showHistory" {
            let vc = segue.destinationViewController as! HistoryTableViewController
            vc.user = self.user
        }
        
    }

    @IBAction func cal(sender: AnyObject) {
        if let phoneNumber: String = user?.objectForKey("tel") as? String{
            if let url = NSURL(string: "tel://\(phoneNumber)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
    }

}
