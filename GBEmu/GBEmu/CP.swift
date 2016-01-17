//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class CP<T : DataLocation where T.DataSize == UInt8> : Instruction {
  
  let register : T
  
  override var description : String {
    get {
      return "CP \(register)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : T) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let oldValue = context.registers[Register.A]
    let valToSub = register.read(context)
    
    let oldValueTyped = UInt16(oldValue)
    let valToSubTyped = UInt16(valToSub)
    
    //Execute SUB
    let newValue = oldValueTyped &- valToSubTyped

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
      context.registers.Flags.resetFlag(Flags.Carry)
    } else {
      context.registers.Flags.setFlag(Flags.Carry)
    }
    
    //HalfCarry Flag
    let halfCarryPosition : UInt16 = 0x10
    let halfCarryMask : UInt16 = 0x0F
    
    if (oldValueTyped & halfCarryMask) < (valToSubTyped & halfCarryMask) {
      context.registers.Flags.resetFlag(Flags.HalfCarry)
    } else {
      context.registers.Flags.setFlag(Flags.HalfCarry)
    }
    
    return InstructionResult(opcode: self.opcode)
  }
}