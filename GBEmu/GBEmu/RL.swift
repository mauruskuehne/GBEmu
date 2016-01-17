//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RL<T : WriteableDataLocation where T.DataSize == UInt8> : Instruction {
  
  let register : T
  
  override var description : String {
    get {
      return "RL \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : T) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    var newVal : UInt8 = 0
    let oldVal = register.read(context)
    
    let shiftedVal = oldVal << 1;
    
    let lastBit = oldVal & 0b1000_0000
    
    if context.registers.Flags.isFlagSet(.Carry) {
      newVal = shiftedVal | 0b0000_0001
    } else {
      newVal = shiftedVal
    }
    
    register.write(newVal, context: context)
    
    if lastBit > 0 {
      context.registers.Flags.setFlag(.Carry)
    } else {
      context.registers.Flags.resetFlag(.Carry)
    }
    
    context.registers.Flags.resetFlag(.HalfCarry)
    context.registers.Flags.resetFlag(.Subtract)
    
    return InstructionResult(opcode: self.opcode)
  }
}