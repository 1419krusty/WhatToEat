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
   var tapRecognizer:UITapGestureRecognizer!
   
   @IBOutlet weak var mealNameText: UITextField!
   @IBOutlet weak var ratingImageView: UIImageView!
   @IBOutlet weak var mealCommentText: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

      self.mealNameText.text = initialMeal.name
      self.mealCommentText.text = initialMeal.comment
      
      self.rating = initialMeal.rating
      self.ratingImageView.image = imageForRating(rating)
      
      let nc:NSNotificationCenter  = NSNotificationCenter.defaultCenter()
      
      nc.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
      nc.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
      
      tapRecognizer = UITapGestureRecognizer(target: self, action: "didTapAnywhere:")
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
      if self.rating == 5 {
         self.rating = 1
      } else {
        self.rating++
      }
      
      ratingImageView.image = imageForRating(rating)
   }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SaveEdittedMeal" {
         let name = self.mealNameText.text
         let comments = self.mealCommentText.text
         
         self.initialMeal.name = name
         self.initialMeal.rating = self.rating
         self.initialMeal.comment = comments
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

}
