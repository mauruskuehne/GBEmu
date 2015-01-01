//
//  SCF.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SCF : Instruction {
  
  override var description : String {
    get {
      return "SCF"
    }
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    context.registers.Flags.setFlag(.Carry)
    context.registers.Flags.resetFlag(.HalfCarry)
    
    return InstructionResult(opcode: self.opcode)
  }
}