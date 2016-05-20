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
   var masterListOfRestaurants: [Restaurant] = []
  
   var refreshPulledHandlerFunc:(()->())!
   var listSortFunc:((Restaurant,Restaurant)->Bool)!
   
   var currentLocation: CLLocation?
   
   var selectedRestaurant: Restaurant?
  
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.refreshPulledHandlerFunc = self.sortByNearestLocation
      self.listSortFunc = byNameAscending
      
      loadRestaurants()
      
      locMgr = CLLocationManager()
      locMgr.delegate = self
      locMgr.desiredAccuracy = kCLLocationAccuracyBest
      
      locMgr.requestWhenInUseAuthorization()
      
      self.refreshControl = UIRefreshControl()
      self.refreshControl?.attributedTitle = NSMutableAttributedString(
         string: "Getting current location",
         attributes: [NSFontAttributeName:UIFont(
            name: "Georgia",
            size: 18.0)!])
      self.refreshControl!.addTarget(self, action: #selector(RestaurantViewController.didPullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
   }
   
   func didPullToRefresh(){
      self.refreshPulledHandlerFunc()
   }
  
   override func viewWillAppear(animated: Bool) {
      self.masterListOfRestaurants = self.masterListOfRestaurants.sort{ self.listSortFunc( $0, $1 ) }
      self.tableView.reloadData()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   // MARK: - New restaurant dialog handlers
   
   @IBAction func saveNewRestaurant(segue:UIStoryboardSegue){
      if let addRestController = segue.sourceViewController as? AddRestaurantViewController {
         
         // Save on disk
         self.masterListOfRestaurants.append(addRestController.rest!)
         saveRestaurants()
         
         // Update current displayed
         let indexPath = NSIndexPath(forItem: self.masterListOfRestaurants.count-1, inSection: 0)
         tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
   }
   
   @IBAction func cancelNewRestaurant(segue:UIStoryboardSegue){
      // DO NOTHING
   }
   
   // MARK: - Table view data source
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.masterListOfRestaurants.count
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath)
      
      let displayedRestaurant = self.masterListOfRestaurants[indexPath.row] as Restaurant
      cell.textLabel!.text = displayedRestaurant.name
      cell.detailTextLabel!.text = displayedRestaurant.locationName
      
      return cell
   }
   
   override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
      self.selectedRestaurant = self.masterListOfRestaurants[indexPath.row]
      return indexPath
   }
   
   // MARK: - Motion handlers
   
   override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
      if motion == .MotionShake {
         var index = 0
         if (  self.currentLocation != nil ) {
            
            // Select random item from near restaurants
            let distanceFromHereInMeters = 48000.0 // meters (30 miles)
            var closeRestaurants = self.masterListOfRestaurants.filter{ $0.locationCoordinate != nil && $0.locationCoordinate?.distanceFromLocation(self.currentLocation!) <= distanceFromHereInMeters }
            index = Int( arc4random_uniform( UInt32( closeRestaurants.count ) ) )
            self.selectedRestaurant = closeRestaurants[index]
         } else {
            
            // Select random item from all restaurants
            index = Int( arc4random_uniform( UInt32( self.masterListOfRestaurants.count ) ) )
            self.selectedRestaurant = self.masterListOfRestaurants[ index ]
         }
         
         performSegueWithIdentifier( "SelectRestaurant", sender: nil )
      }
   }
   
   // MARK: - Navigation
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SelectRestaurant" {
         let mealVC = segue.destinationViewController as! MealViewController
         
         // Needs entire list of restaurants to save updates to restaurant details
         mealVC.masterListOfRestaurants = self.masterListOfRestaurants
         
         // Needs the selected restaurant to display and edit
          mealVC.selectedRestaurant = self.selectedRestaurant
      }
   }
   
   // MARK: - LocationManager
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      locMgr.stopUpdatingLocation()
      
      let locationArray = locations as NSArray
      let locationObj = locationArray.lastObject as! CLLocation
      
       self.refreshControl?.endRefreshing()
      
      self.currentLocation = locationObj
      
      // Next pull down will handle as alphabetical
      self.refreshPulledHandlerFunc = sortListAlphabetically
      self.listSortFunc = byNearestFirst
      
      // Sort master list by nearness
      self.masterListOfRestaurants = self.masterListOfRestaurants .sort{ byNearestFirst( $0, r2: $1 ) }
      self.tableView.reloadData()
      
      // If you are in a restaurant, select that restaurant
      let distanceFromMeInMeters = 50.0
      let closestRestaurant = self.masterListOfRestaurants[0] as Restaurant
      if (  closestRestaurant.locationCoordinate != nil &&
             closestRestaurant.locationCoordinate!.distanceFromLocation( self.currentLocation! ) <= distanceFromMeInMeters )
      {
         self.selectedRestaurant = self.masterListOfRestaurants[0]
         performSegueWithIdentifier("SelectRestaurant", sender: nil)
      }
   }
   
   func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
      locMgr.stopUpdatingLocation()
      
       self.refreshControl?.endRefreshing()
      
      let alert = UIAlertController(title: "Failed to get location", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
      
      print("ERROR getting location: \(error)")
   }
   
   // MARK: - Refresh control handler function
   
   func sortListAlphabetically(){
      self.refreshControl?.endRefreshing()
      
      self.refreshPulledHandlerFunc = sortByNearestLocation
      self.listSortFunc = byNameAscending
      self.currentLocation = nil
      
      self.masterListOfRestaurants = self.masterListOfRestaurants .sort{ byNameAscending( $0, r2: $1 ) }
       self.tableView.reloadData()
   }
   
   func sortByNearestLocation()
   {
      locMgr.requestLocation()
   }
   
   // MARK: - Sorting predicate methods
   
   func byNameAscending( r1:Restaurant, r2:Restaurant )  -> Bool {
      return r1.name < r2.name
   }
   
   func byNearestFirst( r1:Restaurant, r2:Restaurant ) -> Bool {
      return ( ( ( r1.locationCoordinate != nil && r2.locationCoordinate != nil ) &&
                      ( r1.locationCoordinate!.distanceFromLocation( self.currentLocation! ) < r2.locationCoordinate!.distanceFromLocation( self.currentLocation! ) ) ) ||
                 ( r1.locationCoordinate != nil && r2.locationCoordinate == nil) )
   }
   
   // MARK: - Data storage methods
   
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
         let resties: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData)
         self.masterListOfRestaurants = resties as? [Restaurant] ?? []
      }
   }
   
   // TODO: move to common method
   func saveRestaurants() {
      
      let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.masterListOfRestaurants)
      let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
      let documentsDirectory = paths.objectAtIndex(0) as! NSString
      let path = documentsDirectory.stringByAppendingPathComponent("WhatToEat.plist")
   
      saveData.writeToFile(path, atomically: true)
   }
}
