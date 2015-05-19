//
//  EditMealViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/16/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit

class EditMealViewController: UIViewController {

   var initialMeal:Meal!
   var rating:Int = 1
   
   @IBOutlet weak var mealNameText: UITextField!
   @IBOutlet weak var ratingImageView: UIImageView!
   @IBOutlet weak var mealCommentText: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

      self.mealNameText.text = initialMeal.name
      self.mealCommentText.text = initialMeal.comment
      
      self.rating = initialMeal.rating
      self.ratingImageView.image = imageForRating(rating)
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
      if self.rating == 5 {
         self.rating = 1
      } else {
        self.rating++
      }
      
      ratingImageView.image = imageForRating(rating)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
