//
//  CALL.swift
//  GBEmu
//
//  Created by Maurus Kühne on 01.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class CALL<T : DataLocation where T.DataSize == UInt16> : Instruction {
  
  let addressToCall : T
  let condition : JumpCondition?
  
  override var description : String {
    get {
      return "CALL \(addressToCall)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, addressToCall : T, condition : JumpCondition? = nil ) {
    self.addressToCall = addressToCall
    self.condition = condition
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    if let cond = condition {
      if !cond.conditionSatisfied(context) {
        return InstructionResult(opcode: self.opcode, executed: false)
      }
    }
    
    let address = addressToCall.read(context)
    
    context.registers.SP -= 2
    
    context.memoryAccess.write(context.registers.SP, value: context.registers.PC)
    
    context.registers.PC = address
    
    return InstructionResult(opcode: self.opcode)
  }
}