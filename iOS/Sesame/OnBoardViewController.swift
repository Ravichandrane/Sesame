//
//  onBoardViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 10/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit

class OnBoardViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet var login_btn: UIButton!

    var pageViewController: UIPageViewController!
    var pageTitles: [String]!
    var pageContent: [String]!
    var pageImages: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //  STATUS BAR & BACKGROUND
        //
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "isANewUser")
        
        var pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = lightBlue
        pageControl.currentPageIndicatorTintColor = blue
        
        self.pageTitles = ["Bienvenue sur Sesame.", "Sésame, ouvre toi !", "Partagez votre accès."]
        self.pageContent = ["Sesame est un système de garage connecté. Vous pouvez ouvrir, fermer et gérer l’accès à votre domicile en toute sécurité  grâce à une simple pression sur votre téléphone.", "Ne perdez plus votre temps à chercher vos clés. Votre garage s’ouvre lorsque vous êtes à proximité de chez vous.","Partagez l’accès à votre domicile à vos familles et amis en créant des profils utilisateurs types."]
        self.pageImages = ["Control_Anywhere", "Connected_House", "FamilyAndFriends"]
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        var startVC = self.viewControllerAtIndex(0) as ContentBoardViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 150)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.login_btn.backgroundColor = pink
        self.login_btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.login_btn.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> ContentBoardViewController
    {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return ContentBoardViewController()
        }
        
        var vc: ContentBoardViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentBoardViewController") as! ContentBoardViewController
        
        vc.imageFile = self.pageImages[index]
        vc.pageContent = self.pageContent[index]
        vc.titleText = self.pageTitles[index]
        vc.pageIndex = index
        
        return vc
        
        
    }
    
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
        var vc = viewController as! ContentBoardViewController
        var index = vc.pageIndex as Int
        
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
            
        }
        
        index--
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ContentBoardViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count)
        {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }

    
    @IBAction func login(sender: AnyObject) {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
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
