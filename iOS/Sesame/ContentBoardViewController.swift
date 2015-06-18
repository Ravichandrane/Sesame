//
//  ContentBoardViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 10/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit

class ContentBoardViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var image: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var pageContent: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.image = UIImage(named: self.imageFile)
        self.label.text = self.titleText
        self.content.text = self.pageContent
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
