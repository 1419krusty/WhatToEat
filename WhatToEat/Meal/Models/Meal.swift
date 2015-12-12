//
//  Meal.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 5/17/15.
//  Copyright (c) 2015 MacLon Industries. All rights reserved.
//

import Foundation

class Meal : NSObject, NSCoding {
   var name: String
   var rating: Int
   var comment: String
   
    init(name: String, rating: Int, comment: String) {
      self.name = name
      self.rating = rating
      self.comment = comment
   }
   
   required  convenience init?(coder decoder: NSCoder) {
      let name = decoder.decodeObjectForKey("name") as! String
      let comment  = decoder.decodeObjectForKey("comment") as! String
      let rating = decoder.decodeObjectForKey("rating") as! Int
      self.init(name: name, rating:rating, comment: comment)
   }
   
   func encodeWithCoder(coder: NSCoder) {
      coder.encodeObject(self.name, forKey: "name")
      coder.encodeObject(self.comment, forKey: "comment")
      coder.encodeObject(self.rating, forKey: "rating")
   }
}