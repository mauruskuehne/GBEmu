//
//  Display.swift
//  GBEmu
//
//  Created by Maurus Kühne on 14.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class Display {
  
  let memory : MemoryAccessor
  
  init(memory : MemoryAccessor) {
    self.memory = memory
  }
  
  func refresh() {
    var ly = memory.readUInt8(IORegister.LY.rawValue)
    ly += 1
    if ly > 153 {
      ly = 0
    }
    
    memory.write(IORegister.LY.rawValue, value: ly)
    
    if ly > 144 {
      println("in vsync")
    }
  }
  
  func initialize() {
    //Set LCLDC to 0x
    memory.write(IORegister.LCDC.rawValue, value: UInt8(0x91))
  }
}