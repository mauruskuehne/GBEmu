//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RR : RotateInstruction {
  
  let register : ReadWriteDataLocation
  
  override var description : String {
    get {
      return "RR \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : ReadWriteDataLocation) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    var newVal : UInt8 = 0
    let oldVal = register.read(context).getAsUInt8()
    
    let shiftedVal = oldVal >> 1;
    
    let firstBit = oldVal & 0b0000_0001
    
    if context.registers.Flags.isFlagSet(.Carry) {
      newVal = shiftedVal | 0b1000_0000
    } else {
      newVal = shiftedVal
    }
    
    register.write(newVal, context: context)
    
    if firstBit > 0 {
      context.registers.Flags.setFlag(.Carry)
    } else {
      context.registers.Flags.resetFlag(.Carry)
    }
    
    context.registers.Flags.resetFlag(.HalfCarry)
    context.registers.Flags.resetFlag(.Subtract)
    
    return InstructionResult(opcode: self.opcode)
  }
}