//
//  LoginViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 28/05/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController, NewUserDelegate {

    
    //
    //  OUTLET
    //
    
    @IBOutlet var login_btn: UIButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //
        //  STATUS BAR & BACKGROUND
        //
        
        self.startObservingKeyboardEvents()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)

        //
        //  CONTENT
        //
        
        self.login_btn.backgroundColor = pink
        self.login_btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.login_btn.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userAdd" {

            let nav = segue.destinationViewController as! UINavigationController
            let addEventViewController = nav.topViewController as! UserAddViewController
            addEventViewController.delegate = self
        }
    }
    
    //
    //  FUNCTIONS
    //
    
    private func startObservingKeyboardEvents() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillShow:"),
            name:UIKeyboardWillShowNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:Selector("keyboardWillHide:"),
            name:UIKeyboardWillHideNotification,
            object:nil)
    }
    
    private func stopObservingKeyboardEvents() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.frame.origin.y -= keyboardFrame.size.height - 60
        })
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero;
    }
    
    func login(){
        PFUser.logInWithUsernameInBackground(self.emailField.text, password : self.passwordField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.dismissViewControllerAnimated(true, completion: {});
            } else {
                let alertController = UIAlertController(title: "Sesame", message:
                    "Problème lors de la connexion !", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    //
    //  DELEGATE
    //
    
    func newUserAdded(added: Bool) {
        if(added){
            let presentingVC = self.presentingViewController!
            let navigationController = presentingVC is UINavigationController ?     presentingVC as? UINavigationController : presentingVC.navigationController
        
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                navigationController?.popToRootViewControllerAnimated(true)
                return
            })
        }
    }
    
    
    
    //
    //  ACTIONS
    //
    
    @IBAction func login(sender: AnyObject) {
        login()
    }


}
