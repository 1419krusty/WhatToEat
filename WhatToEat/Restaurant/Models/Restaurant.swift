//
//  Restaurant.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import Foundation
import CoreLocation

class Restaurant : NSObject, NSCoding {
   let version: Int = 1
   
   var name: String?
   var comments: String?
   var meals: [Meal] = []
   
   var locationName: String?
   var locationCoordinate: CLLocationCoordinate2D
   
   init(name: String,
      comments: String,
      meals: [Meal],
      locationName: String,
      locationCoordinate: CLLocationCoordinate2D ) {
         
         self.name = name
         self.comments = comments
         self.meals = meals
         
         self.locationName = locationName
         self.locationCoordinate = locationCoordinate
   }
   
   required convenience init?(coder decoder: NSCoder) {
      var theName: String?
      var theComments: String?
      var theMeals: [Meal]!
      var theLocationName: String?
      var theLocationCoordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
      
      let theVersion = decoder.decodeIntegerForKey("version")
      if theVersion == 0 {
         // legacy v1
         theName = decoder.decodeObjectForKey("name") as! String?
         theComments = ""
         theMeals = decoder.decodeObjectForKey("meals") as! [Meal]!
         
         // added in legacy v2
         // NOTE: comments started being used for locationName, this'll help migrate that
         theLocationName = decoder.decodeObjectForKey("comments") as! String?
         if theLocationName == nil {
            theLocationName = ""
         }
      }
      else
      {
         // NEW v1
         theName = decoder.decodeObjectForKey("name") as! String?
         theComments = decoder.decodeObjectForKey("comments") as! String?
         theMeals = decoder.decodeObjectForKey("meals") as! [Meal]!
         
         theLocationName = decoder.decodeObjectForKey("locationName") as! String?
         let latitude = decoder.decodeObjectForKey("coordinateLatitude") as? NSNumber
         let longitude = decoder.decodeObjectForKey("coordinateLongitude") as? NSNumber
         
         if (nil != latitude && nil != longitude)
         {
            theLocationCoordinate = CLLocationCoordinate2D(latitude: latitude!.doubleValue, longitude: longitude!.doubleValue)
         }
      }
      
      self.init(name:theName!,
         comments:theComments!,
         meals:theMeals,
         locationName:theLocationName!,
         locationCoordinate:theLocationCoordinate)
   }
   
   func encodeWithCoder(coder: NSCoder) {
      coder.encodeInt(Int32(self.version), forKey: "version")
      coder.encodeObject(self.name, forKey: "name")
      coder.encodeObject(self.comments, forKey: "comments")
      coder.encodeObject(self.meals, forKey: "meals")
      
      coder.encodeObject(self.locationName, forKey: "locationName")
      
      if ( CLLocationCoordinate2DIsValid( self.locationCoordinate) )
      {
         let latitude:NSNumber = NSNumber(double: self.locationCoordinate.latitude)
         let longitude:NSNumber = NSNumber(double: self.locationCoordinate.longitude)
         coder.encodeObject(latitude, forKey:"coordinateLatitude")
         coder.encodeObject(longitude, forKey:"coordinateLongitude")
      }
   }
}