//
//  BIT.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class BIT<T : WriteableDataLocation where T.DataSize == UInt8> : Instruction {
  
  let register : T
  let bitPosition : UInt8
  
  override var description : String {
    get {
      return "BIT  \(bitPosition), \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : T, bitPosition : UInt8) {
    self.register = register
    self.bitPosition = bitPosition
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {

    let val = register.read(context)
    let bitMask : UInt8 = 1 << bitPosition
    
    let isBitSet = val & bitMask
    
    if isBitSet == 0 {
      context.registers.Flags.setFlag(.Zero)
    } else {
      context.registers.Flags.resetFlag(.Zero)
    }
    
    context.registers.Flags.resetFlag(.Subtract)
    context.registers.Flags.setFlag(.HalfCarry)
    
    return InstructionResult(opcode: self.opcode)
  }
}