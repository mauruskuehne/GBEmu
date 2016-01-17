//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SBC<TRead : DataLocation, TWrite : WriteableDataLocation where TRead.DataSize == TWrite.DataSize, TRead.DataSize == UInt8> : Instruction {
  
  let registerToStore : TWrite
  let registerToSubtract : TRead
  
  override var description : String {
    get {
      return "SBC \(registerToStore), \(registerToSubtract)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, registerToStore : TWrite, registerToSubtract : TRead) {
    self.registerToStore = registerToStore
    self.registerToSubtract = registerToSubtract
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let oldValue = registerToStore.read(context)
    let valToSub = registerToSubtract.read(context)
    
    let oldValueTyped = oldValue
    let valToSubTyped = valToSub
    let carryValue : UInt8 = context.registers.Flags.isFlagSet(Flags.Carry) ? 1 : 0
    
    //Execute SUB
    let newValue = oldValueTyped &- valToSubTyped &- carryValue
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
    if UInt32(oldValueTyped) < (UInt32(valToSubTyped) + UInt32(carryValue)) {
      context.registers.Flags.setFlag(Flags.Carry)
    } else {
      context.registers.Flags.resetFlag(Flags.Carry)
    }
    
    //HalfCarry Flag
    let halfCarryPosition : UInt8 = 0x10
    let halfCarryMask : UInt8 = 0x0F
    
    if (oldValueTyped & halfCarryMask) < ((valToSubTyped & halfCarryMask) + (carryValue & halfCarryMask)){
      context.registers.Flags.setFlag(Flags.HalfCarry)
    } else {
      context.registers.Flags.resetFlag(Flags.HalfCarry)
    }
    
    return InstructionResult(opcode: self.opcode)
  }
}