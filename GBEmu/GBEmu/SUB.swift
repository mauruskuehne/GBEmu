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
    
    let res = SUB.calculateResultForUnsignedSub(context, oldValue: oldValue, valToSub: valToSub)
    
    registerToStore.write(res.result, context: context)
    context.registers.Flags = res.flags
    return InstructionResult(opcode: self.opcode)
  }
  
  class func calculateResultForUnsignedSub(context : ExecutionContext, oldValue : DataLocationSupported, valToSub : DataLocationSupported) -> (result : DataLocationSupported, flags : UInt8){
    var flags = context.registers.Flags
    
    let oldValueTyped = oldValue.getAsUInt16()
    let valToSubTyped = valToSub.getAsUInt16()
    
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
    let halfCarryPosition : UInt16 = 0x10
    let halfCarryMask : UInt16 = 0x0F
    
    if (oldValueTyped & halfCarryMask) < (valToSubTyped & halfCarryMask) {
      flags.setFlag(Flags.HalfCarry)
    } else {
      flags.resetFlag(Flags.HalfCarry)
    }
    
    return (newValue, flags)
  }
}