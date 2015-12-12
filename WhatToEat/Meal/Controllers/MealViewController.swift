//
//  MealViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit

class MealViewController: UITableViewController {

   var restaurants : [Restaurant]!
   var restaurantIndex : Int!
   
   override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   @IBAction func toggleEditingMode(sender:AnyObject){
      let editButton = sender as! UIBarButtonItem
      if self.editing {
         editButton.title = "Edit"
         self.editing = false
      }
      else {
         // TODO: text doesn't update
         editButton.title = "Done"
         self.editing = true
      }
   }
   
   @IBAction func saveNewMeal(segue:UIStoryboardSegue){
      if let addMealVC  = segue.sourceViewController as? AddMealViewController {
         restaurants[restaurantIndex].meals.append( addMealVC.newMeal )
         
         saveMyStuff()
         
         let indexPath = NSIndexPath(forRow: restaurants[restaurantIndex].meals.count-1, inSection: 1)
         tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
   }
   
   @IBAction func cancelNewMeal(segue:UIStoryboardSegue){
      // DO NOTHING
   }
   
   @IBAction func saveEdittedMeal(segue:UIStoryboardSegue){
       self.tableView.reloadData()
      saveMyStuff()
   }
   
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if section == 1 {
         // list of meals section
        return restaurants[restaurantIndex].meals.count
      } else {
         // restaurant details section
         return 1;
      }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      if indexPath.section == 0 {
        let theCell = tableView.dequeueReusableCellWithIdentifier("RestaurantInfoCell", forIndexPath: indexPath) 
         theCell.textLabel!.text = restaurants[restaurantIndex].name
         theCell.detailTextLabel!.text = restaurants[restaurantIndex].comments
         return theCell
      }
      else {
        let cell = tableView.dequeueReusableCellWithIdentifier("MealCell", forIndexPath: indexPath) as! MealCell

      let meal = restaurants[restaurantIndex].meals[indexPath.row] as Meal
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
            editMealVC.initialMeal = restaurants[restaurantIndex].meals[indexPath!.row]
         }
      }
   }
   
   func saveMyStuff() {
      
      let saveData = NSKeyedArchiver.archivedDataWithRootObject(  restaurants);
      let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
      let documentsDirectory = paths.objectAtIndex(0) as! NSString;
      let path = documentsDirectory.stringByAppendingPathComponent("Restaurants.plist");
      
      saveData.writeToFile(path, atomically: true);
   }
   
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
