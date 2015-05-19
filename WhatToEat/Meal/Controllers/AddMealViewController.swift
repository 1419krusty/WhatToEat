//
//  AddMealViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/16/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit

class AddMealViewController: UIViewController {

   var rating:Int = 2
   
   @IBOutlet weak var ratingImage: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
      if rating == 5 {
         self.rating = 1
      } else {
        self.rating++
      }
      
      ratingImage.image = imageForRating(rating)
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
