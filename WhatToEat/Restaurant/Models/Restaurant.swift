//
//  Restaurant.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/14/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import Foundation

class Restaurant : NSObject {
   var name: String
   var meals: [String]
   
   init(name: String, meals: [String]) {
      self.name = name
      self.meals = meals // TODO: deep copy
   }
}