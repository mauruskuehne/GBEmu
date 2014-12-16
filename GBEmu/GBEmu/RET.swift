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
      
      var str = "RET "
      
      if let c = condition {
        str += c.description + "?"
      }
      
      return str
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, condition : JumpCondition? = nil, enableInterrupts : Bool = false ) {
    self.condition = condition
    self.enableInterrupts = enableInterrupts
    
    super.init(opcode: opcode, prefix: prefix)
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