//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SUB : Instruction {
  
  let registerToStore : ReadWriteDataLocation
  let registerToSubtract : ReadableDataLocation
  
  override var description : String {
    get {
      return "SUB \(registerToStore), \(registerToSubtract)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, registerToStore : ReadWriteDataLocation, registerToSubtract : ReadableDataLocation) {
    self.registerToStore = registerToStore
    self.registerToSubtract = registerToSubtract
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let oldValue = registerToStore.read(context)
    let valToSub = registerToSubtract.read(context)
    
    let oldValueTyped = oldValue.getAsUInt16()
    let valToSubTyped = valToSub.getAsUInt16()
    
    
    //Execute SUB
    let newValue = oldValueTyped &- valToSubTyped
    registerToStore.write(newValue, context: context)
    
    //Calculate Flags
    
    // Subtract Flag
    context.registers.Flags.setFlag(Flags.Subtract)
    
    // Zero Flag
    if newValue == 0 {
      context.registers.Flags.setFlag(Flags.Zero)
    } else {
      context.registers.Flags.resetFlag(Flags.Zero)
    }
    
    //Carry Flag
    if oldValueTyped < valToSubTyped {
      context.registers.Flags.setFlag(Flags.Carry)
    } else {
      context.registers.Flags.resetFlag(Flags.Carry)
    }
    
    //HalfCarry Flag
    let halfCarryPosition : UInt16 = 0x10
    let halfCarryMask : UInt16 = 0x0F
    
    if (oldValueTyped & halfCarryMask) < (valToSubTyped & halfCarryMask) {
      context.registers.Flags.setFlag(Flags.HalfCarry)
    } else {
      context.registers.Flags.resetFlag(Flags.HalfCarry)
    }
    
    return InstructionResult(opcode: self.opcode)
  }
}