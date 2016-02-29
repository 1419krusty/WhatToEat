//
//  ButtonProgressMgr.swift
//  WhatToEat
//
//  Created by Bill Scanlon on 2/29/16.
//  Copyright © 2016 MacLon Industries. All rights reserved.
//

import UIKit

class ButtonProgressMgr {
   
   var progressMessage: String!
   var pressedButton: UIButton!
   var oldButtonText: String!
   
   init( withProgressMessage progressMessage: String){
      self.progressMessage = progressMessage
   }
   
   func startedWithButton( button: UIButton ){
      self.pressedButton = button
      self.oldButtonText = button.titleLabel!.text
      
      self.pressedButton.setTitle(self.progressMessage, forState: .Normal)
      self.pressedButton.enabled = false
   }
   
   func completed(){
      self.pressedButton.setTitle(self.oldButtonText, forState: .Normal)
      self.pressedButton.enabled = true
   }
}