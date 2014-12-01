//
//  RET.swift
//  GBEmu
//
//  Created by Maurus Kühne on 01.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RET : Instruction {
  
  let condition : JumpCondition?
  let enableInterrupts : Bool
  
  override var description : String {
    get {
      return "RET \(condition)"
    }
  }
  
  init(condition : JumpCondition? = nil, enableInterrupts : Bool = false ) {
    self.condition = condition
    self.enableInterrupts = enableInterrupts
  }
  
  override func execute(context : ExecutionContext) {
    
    if let cond = condition {
      if !cond.conditionSatisfied(context) {
        return
      }
    }
    
    if enableInterrupts {
      assertionFailure("not yet implemented")
    }
    
    let newPC = context.memoryAccess.readUInt16(context.registers.SP)
    
    context.registers.SP += 2
    
    context.registers.PC = newPC
  }
}