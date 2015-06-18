//
//  UserAddViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 02/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import Parse
import SwiftLoader


protocol NewUserDelegate{
    func newUserAdded(added:Bool)
}

class UserAddViewController: UITableViewController {
    
    
    //
    //  VARIABLE
    //

    var delegate:NewUserDelegate?
    
    
    //
    //  OUTLETS
    //
    
    @IBOutlet var nom: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var prenom: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var code: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //  STATUS BAR & BACKGROUND
        //
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        navigationController!.navigationBar.barTintColor = lightWhite
        navigationController!.navigationBar.tintColor = pink
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:darkBlue]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    //  FUNCTIONS
    //
    
    // Fonction d'ajout d'un utilisateur.
    func userAdd() {
        SwiftLoader.show(animated: true)

        
        var user = PFUser()
        user.username = self.username.text
        user.password = self.password.text
        user.email = self.email.text
        user["userfirstname"] = self.prenom.text
        user["userlastname"] = self.nom.text
        
        
        //Check if Home code exist
        let home = PFQuery(className:"Homes")
        home.getObjectInBackgroundWithId(self.code.text) {
            (home: PFObject?, error: NSError?) -> Void in
            
            //If Home exist save the new user in it
            if error == nil && home != nil {
            user["home"] = home
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo?["error"] as? String
                    showSimpleAlertWithTitle("Error", message: errorString!, viewController: self)
                } else {
                    SwiftLoader.hide()
                    if let deleg = self.delegate
                    {
                        deleg.newUserAdded(true)
                    }
                }
            }
            
        } else {
            println(error)
            }
        }
        
        
    }
    
    //
    //  ACTIONS
    //
    
    @IBAction func add(sender: AnyObject) {
        userAdd()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
