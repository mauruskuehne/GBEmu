//
//  EI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class EI : Instruction {
  
  override var description : String {
    get {
      return "EI"
    }
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    println("enable interrupts")
    
    return InstructionResult(opcode: self.opcode)
  }
}