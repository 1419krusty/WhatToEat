//
//  EditRestaurantViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 12/12/15.
//  Copyright © 2015 MacLon Industries. All rights reserved.
//

import UIKit

class EditRestaurantViewController: UIViewController {

   var initialRestaurant:Restaurant!
   
   @IBOutlet weak var restaurantNameText: UITextField!
   @IBOutlet weak var restaurantCommentText: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

      self.restaurantNameText.text = initialRestaurant.name
      self.restaurantCommentText.text = initialRestaurant.comments
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SaveEdittedRestaurant" {
         let name = self.restaurantNameText.text
         let comments = self.restaurantCommentText.text
         
         self.initialRestaurant.name = name!
         self.initialRestaurant.comments = comments!
      }
    }
}