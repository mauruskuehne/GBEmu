//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class ADC<TRead : DataLocation, TWrite : WriteableDataLocation where TRead.DataSize == TWrite.DataSize, TRead.DataSize == UInt8> : Instruction {
  let registerToStore : TWrite
  let registerToAdd : TRead
  
  override var description : String {
    get {
      return "ADC \(registerToStore), \(registerToAdd)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, registerToStore : TWrite, registerToAdd : TRead) {
    self.registerToStore = registerToStore
    self.registerToAdd = registerToAdd
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {

    let oldValue = registerToStore.read(context)
    let valToAdd = registerToAdd.read(context)
    
    let oldValueTyped = oldValue
    let valToAddTyped = valToAdd
    let carryValue : UInt8 = context.registers.Flags.isFlagSet(Flags.Carry) ? 1 : 0
    
    //Execute ADD
    let newValue = oldValueTyped &+ valToAddTyped &+ carryValue
    registerToStore.write(newValue, context: context)
    
    
    //Calculate Flags
    
    let carryThreshold = UInt16(UInt8.max)
    let halfCarryMask = UInt8(0x000F)
    let halfCarryPosition : UInt8 = 0x10
    
    // Carry Flag
    if (UInt16(oldValueTyped) + UInt16(valToAddTyped) + UInt16(carryValue)) > carryThreshold {
      context.registers.Flags.setFlag(Flags.Carry)
    } else {
      context.registers.Flags.resetFlag(Flags.Carry)
    }
    
    //HalfCarry
    let isHalfCarrySet = (oldValueTyped & halfCarryMask) + (valToAddTyped & halfCarryMask) + (carryValue & halfCarryMask) >= halfCarryPosition
    if isHalfCarrySet {
      context.registers.Flags.setFlag(Flags.HalfCarry)
    } else {
      context.registers.Flags.resetFlag(Flags.HalfCarry)
    }
    
    //Zero
    if newValue == 0 {
      context.registers.Flags.setFlag(Flags.Zero)
    } else {
      context.registers.Flags.resetFlag(Flags.Zero)
    }
    
    context.registers.Flags.resetFlag(Flags.Subtract)
    
    return InstructionResult(opcode: self.opcode)
  }
}