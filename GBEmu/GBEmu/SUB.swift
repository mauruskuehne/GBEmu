//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SUB<TRead : DataLocation, TWrite : WriteableDataLocation where TRead.DataSize == TWrite.DataSize, TRead.DataSize == UInt8> : Instruction {
  
  let registerToStore : TWrite
  let registerToSubtract : TRead
  
  override var description : String {
    get {
      return "SUB \(registerToStore), \(registerToSubtract)"
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
    
    let res = SUB.calculateResultForUnsignedSub(context, oldValue: oldValue, valToSub: valToSub)
    
    registerToStore.write(res.result, context: context)
    context.registers.Flags = res.flags
    return InstructionResult(opcode: self.opcode)
  }
  
  class func calculateResultForUnsignedSub(context : ExecutionContext, oldValue : TWrite.DataSize, valToSub : TWrite.DataSize) -> (result : TRead.DataSize, flags : UInt8){
    var flags = context.registers.Flags
    
    let oldValueTyped = oldValue
    let valToSubTyped = valToSub
    
    //Execute SUB
    let newValue = oldValueTyped &- valToSubTyped
    
    //Calculate Flags
    
    // Subtract Flag
    flags.setFlag(Flags.Subtract)
    
    // Zero Flag
    if newValue == 0 {
      flags.setFlag(Flags.Zero)
    } else {
      flags.resetFlag(Flags.Zero)
    }
    
    //Carry Flag
    if oldValueTyped < valToSubTyped {
      flags.setFlag(Flags.Carry)
    } else {
      flags.resetFlag(Flags.Carry)
    }
    
    //HalfCarry Flag
    let halfCarryPosition : UInt8 = 0x10
    let halfCarryMask : UInt8 = 0x0F
    
    if (oldValueTyped & halfCarryMask) < (valToSubTyped & halfCarryMask) {
      flags.setFlag(Flags.HalfCarry)
    } else {
      flags.resetFlag(Flags.HalfCarry)
    }
    
    return (newValue, flags)
  }
}