//
//  RestaurantViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantViewController: UITableViewController, CLLocationManagerDelegate {
   
   var locMgr: CLLocationManager!
   var restaurants : [Restaurant] = []
  
   var firstAppearance = true
   var selectedRowIndex = 0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      loadRestaurants()
      
      locMgr = CLLocationManager()
      locMgr.delegate = self
      locMgr.desiredAccuracy = kCLLocationAccuracyBest
      
      locMgr.requestWhenInUseAuthorization()
      
   }
   
   override func viewWillAppear(animated: Bool) {
      self.tableView.reloadData()
   }
   
   override func viewDidAppear(animated: Bool) {
      // Need to be sure table view is loaded
      if self.firstAppearance{
         self.firstAppearance = false
         locMgr.requestLocation()
      }
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - New restaurant dialog handlers
   
   @IBAction func saveNewRestaurant(segue:UIStoryboardSegue){
      if let addRestController = segue.sourceViewController as? AddRestaurantViewController {
         restaurants.append(addRestController.rest!)
         
         saveRestaurants()
         
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
      cell.detailTextLabel!.text = restaurant.locationName
      
      return cell
   }
   
   override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
      self.selectedRowIndex = indexPath.row
      return indexPath
   }
   
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SelectRestaurant" {
         let mealVC = segue.destinationViewController as! MealViewController
         mealVC.restaurants = self.restaurants
         mealVC.restaurantIndex = self.selectedRowIndex
      }
   }
   
   // MARK: - LocationManager
   func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
      locMgr.stopUpdatingLocation()
      
      print(error)
   }
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      locMgr.stopUpdatingLocation()
      
      let locationArray = locations as NSArray
      let locationObj = locationArray.lastObject as! CLLocation
      
      if let i = self.restaurants.indexOf( { $0.locationCoordinate != nil && $0.locationCoordinate!.distanceFromLocation( locationObj) < 50 })
      {
         self.selectedRowIndex = i
         performSegueWithIdentifier("SelectRestaurant", sender: nil)
      }
   }
   
   // MARK: - Private methods
   
   func loadRestaurants() {
      let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
      let documentsDirectory = paths[0]
      let path = (documentsDirectory as NSString).stringByAppendingPathComponent("WhatToEat.plist")
      let fileManager = NSFileManager.defaultManager()
      
      // check if file exist
      if !fileManager.fileExistsAtPath(path) {
         // create an empty file if it doesn't exist
         if let bundle = NSBundle.mainBundle().pathForResource(nil, ofType: "plist") {
            do {
               try fileManager.copyItemAtPath(bundle, toPath: path)
            } catch _ {
               // TODO: indicate problem
            }
         }
      }
      
      if let rawData = NSData(contentsOfFile: path) {
         // do we get serialized data back from the attempted path?
         // if so, unarchive it into an AnyObject, and then convert to an array of Restaurant, if possible
         let resties: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
         self.restaurants = resties as? [Restaurant] ?? [];
      }
   }
   
   // TODO: move to common method
   func saveRestaurants() {
      
      let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.restaurants);
      let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
      let documentsDirectory = paths.objectAtIndex(0) as! NSString;
      let path = documentsDirectory.stringByAppendingPathComponent("WhatToEat.plist");
      
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