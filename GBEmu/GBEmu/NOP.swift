//
//  NOP.swift
//  GBEmu
//
//  Created by Maurus Kühne on 16.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class NOP : Instruction {
  
  override var description : String {
    get {
      return "NOP"
    }
  }
  
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    //NOP
    
    return InstructionResult(opcode: self.opcode)
  }
}