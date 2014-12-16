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
    
    let newVal = context.registers.A >> 1;
    
    let firstBit = context.registers.A & 0b0000_0001
    
    if context.registers.Flags.isFlagSet(.Carry) {
      context.registers.A = newVal | 0b1000_0000
    } else {
      context.registers.A = newVal
    }
    
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