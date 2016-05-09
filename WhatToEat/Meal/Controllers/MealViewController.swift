//
//  MealViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit

class MealViewController: UITableViewController {
   
   var masterListOfRestaurants : [Restaurant]!
   var selectedRestaurant : Restaurant!
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   // MARK: - New Meal dialog handlers
   
   @IBAction func saveNewMeal(segue:UIStoryboardSegue){
      if let addMealVC  = segue.sourceViewController as? AddMealViewController {
         selectedRestaurant.meals.append( addMealVC.newMeal )
         
         saveRestaurants()
         
         let indexPath = NSIndexPath(forRow: selectedRestaurant.meals.count-1, inSection: 1)
         tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
   }
   
   @IBAction func cancelNewMeal(segue:UIStoryboardSegue){
      // DO NOTHING
   }
   
   @IBAction func saveEdittedMeal(segue:UIStoryboardSegue){
      self.tableView.reloadData()
      saveRestaurants()
   }
   
   @IBAction func saveEdittedRestaurant(segue:UIStoryboardSegue){
      if let editRestVC = segue.sourceViewController as? EditRestaurantViewController {
         
         selectedRestaurant.name = editRestVC.initialRestaurant.name
         selectedRestaurant.locationName = editRestVC.initialRestaurant.locationName
         selectedRestaurant.comments = editRestVC.initialRestaurant.comments
         
         saveRestaurants()
         
         self.tableView.reloadData()
      }
   }
   
   // MARK: - Table view data source
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 2
   }
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if section == 1 {
         // list of meals section
         return selectedRestaurant.meals.count
      } else {
         // restaurant details section
         return 1;
      }
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      if indexPath.section == 0 {
         let theCell = tableView.dequeueReusableCellWithIdentifier("RestaurantInfoCell", forIndexPath: indexPath)
         
         theCell.textLabel!.text = selectedRestaurant.name
         theCell.detailTextLabel!.text = selectedRestaurant.locationName
         
         return theCell
      }
      else {
         let cell = tableView.dequeueReusableCellWithIdentifier("MealCell", forIndexPath: indexPath) as! MealCell
         
         let meal = selectedRestaurant.meals[indexPath.row] as Meal
         cell.mealNameLabel!.text = meal.name
         cell.ratingImageView.image = imageForRating(meal.rating)
         
         return cell
      }
   }
   
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "EditMeal" {
         if let editMealVC = segue.destinationViewController as? EditMealViewController {
            let indexPath = self.tableView .indexPathForCell(sender as! UITableViewCell)
            editMealVC.initialMeal = selectedRestaurant.meals[indexPath!.row]
         }
      }
      else if segue.identifier == "EditRestaurant" {
         if let editRestaurantVC = segue.destinationViewController as? EditRestaurantViewController {
            editRestaurantVC.initialRestaurant = selectedRestaurant
         }
      }
   }
   
   // TODO: move to common method
   func saveRestaurants() {
      
      let saveData = NSKeyedArchiver.archivedDataWithRootObject(  self.masterListOfRestaurants );
      let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
      let documentsDirectory = paths.objectAtIndex(0) as! NSString;
      
      let path = documentsDirectory.stringByAppendingPathComponent("WhatToEat.plist");
      
      saveData.writeToFile(path, atomically: true);
   }
   
   // TODO: move to a custom UIImageView
   func imageForRating(rating:Int) -> UIImage? {
      switch rating {
      case 1:
         return UIImage(named: "1StarSmall")
      case 2:
         return UIImage(named: "2StarsSmall")
      case 3:
         return UIImage(named: "3StarsSmall")
      case 4:
         return UIImage(named: "4StarsSmall")
      case 5:
         return UIImage(named: "5StarsSmall")
      default:
         return nil
      }
   }
   
   // Override to support conditional editing of the table view.
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      return  indexPath.section != 0
   }
   
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