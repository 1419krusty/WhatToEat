//
//  AddMealViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/16/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit

class AddMealViewController: UIViewController {

   @IBOutlet weak var mealNameText: UITextField!
   @IBOutlet weak var ratingImage: UIImageView!
   @IBOutlet weak var mealCommentsText: UITextField!
   
   var newMeal: Meal!
   var rating: Int = 1
   var tapRecognizer: UITapGestureRecognizer!
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let nc: NSNotificationCenter  = NSNotificationCenter.defaultCenter()
      
      nc.addObserver(self, selector: #selector(AddMealViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
      nc.addObserver(self, selector: #selector(AddMealViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
      
      tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMealViewController.didTapAnywhere(_:)))
    }

   func keyboardWillShow(note:NSNotification ) {
      self.view.addGestureRecognizer(tapRecognizer)
   }
   
   func keyboardWillHide(note:NSNotification ) {
      self.view.removeGestureRecognizer(tapRecognizer)
   }
   
   func didTapAnywhere (recognizer:UITapGestureRecognizer){
      self.view.endEditing(true)
   }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
      if rating == 5 {
         self.rating = 1
      } else {
        self.rating += 1
      }
      
      ratingImage.image = imageForRating(rating)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SaveNewMeal" {
         let name = self.mealNameText.text
         let comments = self.mealCommentsText.text
         self.newMeal = Meal(name: name!, rating: self.rating, comment: comments!)
      }
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
