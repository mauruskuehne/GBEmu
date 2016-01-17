//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class XOR<T : DataLocation where T.DataSize == UInt8> : Instruction {
  
  let register : T
  
  override var description : String {
    get {
      return "XOR \(register)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : T) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    context.registers.A = context.registers.A ^ register.read(context)
    
    if context.registers.A == 0 {
      context.registers.Flags.setFlag(Flags.Zero)
    } else {
      context.registers.Flags.resetFlag(Flags.Zero)
    }
    
    context.registers.Flags.resetFlag(Flags.Subtract)
    context.registers.Flags.resetFlag(Flags.HalfCarry)
    context.registers.Flags.resetFlag(Flags.Carry)
    
    return InstructionResult(opcode: self.opcode)
  }
}