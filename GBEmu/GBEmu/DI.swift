//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class DI : Instruction {
  
  override var description : String {
    get {
      return "DI"
    }
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    println("disable interrupts")
    
    context.interruptMasterEnable = false
    
    return InstructionResult(opcode: self.opcode)
  }
}