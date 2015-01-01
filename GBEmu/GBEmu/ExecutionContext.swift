//
//  EmulationContext.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class ExecutionContext  {
  
  let CLOCK_SPEED = UInt32(4.194304 * 1000 * 1000)
  let CYCLES_PER_FRAME = UInt32( (4.194304 * 1000 * 1000) / 59.73 )
  
  let registers : Registers
  let memoryAccess : MemoryAccessor
  
  var interruptMasterEnable = true
  
  private var _usedClockCyclesInCurrentFrame : UInt32 = 0
  var usedClockCyclesInCurrentFrame : UInt32 {
    get {
      return _usedClockCyclesInCurrentFrame
    }
    set(value) {
      if value >= CYCLES_PER_FRAME {
        _usedClockCyclesInCurrentFrame = 0
      } else {
        _usedClockCyclesInCurrentFrame = value
      }
    }
  }
  
  init(registers : Registers, memoryAccess : MemoryAccessor) {
    self.registers = registers;
    self.memoryAccess = memoryAccess
  }
}