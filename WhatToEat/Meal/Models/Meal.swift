//
//  Meal.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/17/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import Foundation

class Meal : NSObject {
   var name: String
   var rating: Int
   var comment: String
   
   init(name: String, rating: Int, comment: String) {
      self.name = name
      self.rating = rating
      self.comment = comment
   }
}