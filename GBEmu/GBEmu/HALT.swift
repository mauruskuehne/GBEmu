//
//  HALT.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class HALT : Instruction {
  
  override var description : String {
    get {
      return "HALT"
    }
  }
  
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    //HALT
    assertionFailure("HALT")
    
    return InstructionResult(opcode: self.opcode)
  }
}