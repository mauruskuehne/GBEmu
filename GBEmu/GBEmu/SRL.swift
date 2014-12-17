//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SRL : RotateInstruction {
  
  let register : ReadWriteDataLocation
  
  override var description : String {
    get {
      return "SRL \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : ReadWriteDataLocation) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    let oldVal = register.read(context).getAsUInt8()
    
    let shiftedVal = oldVal >> 1;
    
    let firstBit = oldVal & 0b000_0001
    
    if firstBit > 0 {
      context.registers.Flags.setFlag(.Carry)
    } else {
      context.registers.Flags.resetFlag(.Carry)
    }
    
    if shiftedVal == 0 {
      context.registers.Flags.setFlag(.Zero)
    } else {
      context.registers.Flags.resetFlag(.Zero)
    }
    
    context.registers.Flags.resetFlag(.HalfCarry)
    context.registers.Flags.resetFlag(.Subtract)
    
    register.write(shiftedVal, context: context)
    
    return InstructionResult(opcode: self.opcode)
  }
}