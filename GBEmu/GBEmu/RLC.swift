//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RLC<T : WriteableDataLocation where T.DataSize == UInt8> : Instruction {
  
  let register : T
  
  override var description : String {
    get {
      return "RLC \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : T) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    var newVal : UInt8
    let oldVal = register.read(context)
    
    let shiftedVal = oldVal << 1;
    
    let lastBit = oldVal & 0b1000_0000
    
    if lastBit > 0 {
      newVal = shiftedVal | 1
      context.registers.Flags.setFlag(.Carry)
    } else {
      newVal = shiftedVal
      context.registers.Flags.resetFlag(.Carry)
    }
    
    register.write(newVal, context: context)
    
    context.registers.Flags.resetFlag(.HalfCarry)
    context.registers.Flags.resetFlag(.Subtract)
    
    return InstructionResult(opcode: self.opcode)
  }
}