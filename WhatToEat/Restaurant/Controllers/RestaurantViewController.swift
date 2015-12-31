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
      
      self.refreshControl = UIRefreshControl()
      self.refreshControl?.attributedTitle = NSMutableAttributedString(
         string: "Getting current location",
         attributes: [NSFontAttributeName:UIFont(
            name: "Georgia",
            size: 18.0)!])
      self.refreshControl!.addTarget(self, action: Selector("theRefresh"), forControlEvents: UIControlEvents.ValueChanged)
      
      locMgr = CLLocationManager()
      locMgr.delegate = self
      locMgr.desiredAccuracy = kCLLocationAccuracyBest
      
      locMgr.requestWhenInUseAuthorization()
   }
   
   func theRefresh(){
         locMgr.requestLocation()
   }
   
   override func viewWillAppear(animated: Bool) {
      self.tableView.reloadData()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
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
      return self.restaurants.count
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath)
      
      let restaurant = self.restaurants[indexPath.row] as Restaurant
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
      
      self.refreshControl?.endRefreshing()
      
      print("ERROR getting location: \(error)")
   }
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      locMgr.stopUpdatingLocation()
      
      self.refreshControl?.endRefreshing()
      
      let locationArray = locations as NSArray
      let locationObj = locationArray.lastObject as! CLLocation
      
      if let restaurantIndex = self.restaurants.indexOf( { $0.locationCoordinate != nil && $0.locationCoordinate!.distanceFromLocation( locationObj) < 50 })
      {
         self.selectedRowIndex = restaurantIndex
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
         let unsortedRestaurants = resties as? [Restaurant] ?? [];
         
         self.restaurants = unsortedRestaurants.sort {$0.name < $1.name}
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