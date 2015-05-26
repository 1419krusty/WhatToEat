//
//  Restaurant.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import Foundation

class Restaurant : NSObject, NSCoding {
   var name: String?
   var meals: [Meal] = []
   
   init(name: String, meals: [Meal]) {
      self.name = name
      self.meals = meals
   }
   
   required convenience init(coder decoder: NSCoder) {
      let name = decoder.decodeObjectForKey("name") as! String?
      let meals = decoder.decodeObjectForKey("meals") as! [Meal]!
      self.init(name:name!, meals:meals)
   }
   
   func encodeWithCoder(coder: NSCoder) {
      coder.encodeObject(self.name, forKey: "name")
      coder.encodeObject(self.meals, forKey: "meals")
   }
}