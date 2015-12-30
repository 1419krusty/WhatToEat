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
   
   var name: String!
   var comments: String!
   var meals: [Meal] = []
   
   var locationName: String!
   var locationCoordinate: CLLocation?
   
   init(name: String,
      comments: String,
      meals: [Meal],
      locationName: String,
      locationCoordinate: CLLocation?) {
         
         self.name = name
         self.comments = comments
         self.meals = meals
         
         self.locationName = locationName
         self.locationCoordinate = locationCoordinate
   }
   
   required convenience init?(coder decoder: NSCoder) {
      var theName: String
      var theComments: String
      var theMeals: [Meal]
      var theLocationName: String
      var theLocationCoordinate: CLLocation?
      
      let theVersion = decoder.decodeIntegerForKey("version")
      if theVersion == 0 {
         // legacy v1
         theName = decoder.decodeObjectForKey("name") as! String
         theComments = ""
         theMeals = decoder.decodeObjectForKey("meals") as! [Meal]
         
         // added in legacy v2
         // NOTE: comments started being used for locationName, this'll help migrate that
         theLocationName = decoder.decodeObjectForKey("comments") as! String
      }
      else
      {
         // NEW v1
         theName = decoder.decodeObjectForKey("name") as! String
         theComments = decoder.decodeObjectForKey("comments") as! String
         theMeals = decoder.decodeObjectForKey("meals") as! [Meal]
         
         theLocationName = decoder.decodeObjectForKey("locationName") as! String
         theLocationCoordinate = decoder.decodeObjectForKey("locationCoordinate") as! CLLocation?
      }
      
      self.init(name:theName,
         comments:theComments,
         meals:theMeals,
         locationName:theLocationName,
         locationCoordinate:theLocationCoordinate)
   }
   
   func encodeWithCoder(coder: NSCoder) {
      coder.encodeInt(Int32(self.version), forKey: "version")
      coder.encodeObject(self.name, forKey: "name")
      coder.encodeObject(self.comments, forKey: "comments")
      coder.encodeObject(self.meals, forKey: "meals")
      
      coder.encodeObject(self.locationName, forKey: "locationName")
      
      coder.encodeObject(self.locationCoordinate, forKey: "locationCoordinate")
   }
}