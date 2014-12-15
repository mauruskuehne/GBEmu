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
    
    //let lcdc = memory.readUInt8(IORegister.LCDC.rawValue)
    
  }
  
  func initialize() {
    //Set LCLDC to 0x
    memory.write(IORegister.LCDC.rawValue, value: UInt8(0x91))
  }
}