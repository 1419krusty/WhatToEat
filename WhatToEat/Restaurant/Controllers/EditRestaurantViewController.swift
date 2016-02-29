//
//  EditRestaurantViewController.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 12/12/15.
//  Copyright © 2015 MacLon Industries. All rights reserved.
//

import UIKit
import CoreLocation

class EditRestaurantViewController: UIViewController, CLLocationManagerDelegate {
   
   @IBOutlet weak var restaurantNameText: UITextField!
   @IBOutlet weak var restaurantLocationNameText: UITextField!
   @IBOutlet weak var restaurantGPSLocationLabel: UILabel!
   
   var initialRestaurant: Restaurant!
   var editedLocationCoordinate: CLLocation?
   var tapRecognizer: UITapGestureRecognizer!
   
   var locMgr: CLLocationManager!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.restaurantNameText.text = initialRestaurant.name
      self.restaurantLocationNameText.text = initialRestaurant.locationName
      
      if let coord = self.initialRestaurant.locationCoordinate {
         self.editedLocationCoordinate = initialRestaurant.locationCoordinate
         self.restaurantGPSLocationLabel.text = "\(coord.coordinate.latitude), \(coord.coordinate.longitude)"
      }
      
      locMgr = CLLocationManager()
      locMgr.delegate = self
      locMgr.desiredAccuracy = kCLLocationAccuracyBest
      
      let nc: NSNotificationCenter  = NSNotificationCenter.defaultCenter()
      
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
   
   @IBAction func gpsClicked( sender: UIButton ){
      locMgr.requestLocation()
   }
   
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SaveEdittedRestaurant" {
         let name = self.restaurantNameText.text
         let locationName = self.restaurantLocationNameText.text
         
         self.initialRestaurant.name = name!
         self.initialRestaurant.locationName = locationName!
         self.initialRestaurant.locationCoordinate = self.editedLocationCoordinate
      }
   }
   
   // MARK: - LocationManager
   
   func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
      locMgr.stopUpdatingLocation()
      
      print(error)
   }
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      locMgr.stopUpdatingLocation()
      
      let locationArray = locations as NSArray
      let locationObj = locationArray.lastObject as! CLLocation
      let coord = locationObj.coordinate
      
      self.restaurantGPSLocationLabel.text = "\(coord.latitude), \(coord.longitude)"
      
      self.editedLocationCoordinate = locationObj
   }
}