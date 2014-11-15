//
//  EmulationEngine.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class EmulationEngine {
  
  var romData : NSData!
  
  init() {
    
  }
  
  func loadRom(romData : NSData) {
    self.romData = romData
  }
  
}