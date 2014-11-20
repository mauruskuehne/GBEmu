//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class ADD : Instruction {
  
  let registerToStore : ReadWriteDataLocation
  let registerToAdd : ReadableDataLocation
  
  override var description : String {
    get {
      return "ADD \(registerToStore), \(registerToAdd)"
    }
  }
  
  init(registerToStore : ReadWriteDataLocation, registerToAdd : ReadableDataLocation) {
    self.registerToStore = registerToStore
    self.registerToAdd = registerToAdd
  }
  
  override func execute(context : ExecutionContext) {
    
    
    let oldValue = registerToStore.read(context)
    let valToAdd = registerToAdd.read(context)
    
    let is8BitArithmetic = oldValue is UInt8
    
    let oldValueTyped = oldValue.getAsUInt16()
    let valToAddTyped = valToAdd.getAsUInt16()
    
    
    //Execute ADD
    let newValue = oldValueTyped &+ valToAddTyped
    registerToStore.write(newValue, context: context)
    
    
    //Calculate Flags
    
    let carryThreshold = UInt32(is8BitArithmetic ? UInt16(UInt8.max) : UInt16.max)
    let halfCarryMask = is8BitArithmetic ? UInt16(0x000F) : UInt16(0x0FFF)
    let halfCarryPosition : UInt16 = is8BitArithmetic ? 0x10 : 0x1000
    
    // Carry Flag
    if (UInt32(oldValueTyped) + UInt32(valToAddTyped)) > carryThreshold {
      context.registers.Flags.setFlag(Flags.Carry)
    }
    
    //HalfCarry
    let isHalfCarrySet = (oldValueTyped & halfCarryMask) + (valToAddTyped & halfCarryMask) & halfCarryPosition > 0
    if isHalfCarrySet {
      context.registers.Flags.setFlag(Flags.HalfCarry)
    }
    
    //Zero
    if newValue == 0 && is8BitArithmetic {
      context.registers.Flags.setFlag(Flags.Zero)
    }
    
    context.registers.Flags.resetFlag(Flags.Subtract)
    
  }
}