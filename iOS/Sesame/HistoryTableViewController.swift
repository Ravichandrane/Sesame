//
//  ProfilTableViewController.swift
//  Sesame
//
//  Created by Pierre-Olivier POTIER on 14/06/2015.
//  Copyright (c) 2015 Pierre-Olivier POTIER. All rights reserved.
//

import UIKit
import Parse

class HistoryTableViewController: UITableViewController {

    var dataParse:NSMutableArray = NSMutableArray()
    var user:PFObject?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfos()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    //  FUNCTIONS
    //
    
    func getInfos(){
        
        self.dataParse.removeAllObjects()
        
        var query = PFQuery(className: "History")
        
        query.whereKey("user", equalTo: self.user!);
        
        query.findObjectsInBackgroundWithBlock({
            (success:[AnyObject]?, error: NSError?) -> Void in
            
            if let objects = success as? [PFObject] {
                for object in objects {
                    self.dataParse.addObject(object)
                }
            }
            
            if(self.dataParse.count == 0){                
                
                var refreshAlert = UIAlertController(title: "Sesame", message: "Aucun historique pour cet utilisateur.", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.navigationController?.popViewControllerAnimated(true)
                }))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
            }
            
            self.title = "Historique (\(self.dataParse.count))"

            
            self.tableView.reloadData()
        })
        
    }

    // MARK - TABLE VIEW
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataParse.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        let cellDataParse:PFObject = self.dataParse.objectAtIndex(indexPath.row) as! PFObject
        
        cell.textLabel?.text = nsdateToString(cellDataParse.createdAt!)
        return cell
    }
    

}
