//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RRC<T : WriteableDataLocation where T.DataSize == UInt8> : Instruction {
  
  let register : T
  
  override var description : String {
    get {
      return "RRC \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : T) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    var newVal : UInt8 = 0
    let oldVal = register.read(context)
    
    let shiftedVal = oldVal >> 1;
    
    let firstBit = oldVal & 0b0000_0001
    
    if firstBit > 0 {
      newVal = shiftedVal | 0b1000_0000
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