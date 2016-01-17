//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SRA<T : WriteableDataLocation where T.DataSize == UInt8> : Instruction {
  
  let register : T
  let one : T.DataSize = 1
  
  override var description : String {
    get {
      return "SRA \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : T) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    let oldVal = register.read(context)
    
    let shiftedVal = oldVal >> one;
    
    let firstBit = oldVal & 0b000_0001
    let lastBit = oldVal & 0b100_0000
    
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
    
    let newVal = shiftedVal | lastBit
    register.write(shiftedVal, context: context)
    
    return InstructionResult(opcode: self.opcode)
  }
}