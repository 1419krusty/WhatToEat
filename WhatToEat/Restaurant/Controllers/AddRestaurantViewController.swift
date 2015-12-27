//
//  AddRestaurantViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit
import CoreLocation

class AddRestaurantViewController: UIViewController {

   @IBOutlet weak var restaurantNameText: UITextField!
   @IBOutlet weak var restaurantLocationNameText: UITextField!
   
   var rest : Restaurant?
   var locationName : String?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SaveRestaurant" {
         rest = Restaurant(name: self.restaurantNameText.text!,
            comments:"",
            meals: [],
            locationName: self.restaurantLocationNameText.text!,
            locationCoordinate:kCLLocationCoordinate2DInvalid)
      }
    }
}
