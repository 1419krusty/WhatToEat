//
//  RestaurantViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit

class RestaurantViewController: UITableViewController {

   var restaurants : [Restaurant] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      loadMyStuff()
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   @IBAction func saveNewRestaurant(segue:UIStoryboardSegue){
      if let addRestController = segue.sourceViewController as? AddRestaurantViewController {
         restaurants.append(addRestController.rest!)
         
         saveMyStuff()
         
         let indexPath = NSIndexPath(forItem: restaurants.count-1, inSection: 0)
         tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
   }
   
   @IBAction func cancelNewRestaurant(segue:UIStoryboardSegue){
      // DO NOTHING
   }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return restaurants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath) 
      
      let restaurant = restaurants[indexPath.row] as Restaurant
      cell.textLabel!.text = restaurant.name

        return cell
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SelectRestaurant" {
         //         let navVC = segue.destinationViewController as! UINavigationController
         //         let mealVC = seq.childViewControllers[0] as! MealViewController
         let mealVC = segue.destinationViewController as! MealViewController
         mealVC.restaurants = self.restaurants
         let indexPath = self.tableView .indexPathForCell(sender as! UITableViewCell)
         mealVC.restaurantIndex = indexPath!.row
      }
   }

   func loadMyStuff() {
      // load restaurants
      let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
      let documentsDirectory = paths[0] 
      let path = (documentsDirectory as NSString).stringByAppendingPathComponent("Restaurants.plist")
      let fileManager = NSFileManager.defaultManager()
      
      // check if file exists
      if !fileManager.fileExistsAtPath(path) {
         // create an empty file if it doesn't exist
         if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
            do {
               try fileManager.copyItemAtPath(bundle, toPath: path)
            } catch _ {
            }
         }
      }
      
      if let rawData = NSData(contentsOfFile: path) {
         // do we get serialized data back from the attempted path?
         // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
         let resties: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
         self.restaurants = resties as? [Restaurant] ?? [];
      }
   }
   
   func saveMyStuff() {
      // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
      let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.restaurants);
      let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
      let documentsDirectory = paths.objectAtIndex(0) as! NSString;
      let path = documentsDirectory.stringByAppendingPathComponent("Restaurants.plist");
      
      saveData.writeToFile(path, atomically: true);
   }
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

}
