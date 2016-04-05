//
//  AddRestaurantViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import UIKit
import CoreLocation

class AddRestaurantViewController: UIViewController, CLLocationManagerDelegate {
   
   @IBOutlet weak var restaurantNameText: UITextField!
   @IBOutlet weak var restaurantLocationNameText: UITextField!
   @IBOutlet weak var restaurantGPSLocationLabel: UILabel!
   
   var rest: Restaurant?
   var editedLocationCoordinate: CLLocation?
   var tapRecognizer: UITapGestureRecognizer!
   
   var locMgr: CLLocationManager!
   var buttonMgr: ButtonProgressMgr!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      locMgr = CLLocationManager()
      locMgr.delegate = self
      locMgr.desiredAccuracy = kCLLocationAccuracyBest
      
      buttonMgr = ButtonProgressMgr( withProgressMessage: "Looking...")
      
      let nc: NSNotificationCenter  = NSNotificationCenter.defaultCenter()
      
      nc.addObserver(self, selector: #selector(AddRestaurantViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
      nc.addObserver(self, selector: #selector(AddRestaurantViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
      
      tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddRestaurantViewController.didTapAnywhere(_:)))
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
   
   func viewTapped()
   {
      self.view.endEditing(true)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   @IBAction func gpsClicked( sender: UIButton ){
      self.buttonMgr.startedWithButton( sender )
      self.locMgr.requestLocation()
   }
   
   // MARK: - Navigation
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SaveRestaurant" {
         rest = Restaurant(name: self.restaurantNameText.text!,
            comments:"",
            meals: [],
            locationName: self.restaurantLocationNameText.text!,
            locationCoordinate:editedLocationCoordinate)
      }
   }
   
   // MARK: - LocationManager
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      self.locMgr.stopUpdatingLocation()
      
      let locationArray = locations as NSArray
      let locationObj = locationArray.lastObject as! CLLocation
      let coord = locationObj.coordinate
      
      self.editedLocationCoordinate = locationObj
      
      self.restaurantGPSLocationLabel.text = "\(coord.latitude), \(coord.longitude)"
      
      self.buttonMgr.completed()
   }
   
   func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
      locMgr.stopUpdatingLocation()
      
      self.buttonMgr.completed()
      
      print(error)
   }
}