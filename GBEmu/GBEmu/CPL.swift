//
//  CPL.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class CPL : Instruction {
  
  override var description : String {
    get {
      return "CPL"
    }
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let val = ~(context.registers.A)
    context.registers.A = val
    
    context.registers.Flags.setFlag(.Subtract)
    context.registers.Flags.setFlag(.HalfCarry)
    
    return InstructionResult(opcode: self.opcode)
  }
}