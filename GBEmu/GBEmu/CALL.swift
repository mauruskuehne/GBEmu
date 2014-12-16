//
//  CALL.swift
//  GBEmu
//
//  Created by Maurus Kühne on 01.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class CALL : Instruction {
  
  let addressToCall : ReadableDataLocation
  let condition : JumpCondition?
  
  override var description : String {
    get {
      return "CALL \(addressToCall)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, addressToCall : ReadableDataLocation, condition : JumpCondition? = nil ) {
    self.addressToCall = addressToCall
    self.condition = condition
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) {
    
    if let cond = condition {
      if !cond.conditionSatisfied(context) {
        return
      }
    }
    
    let address = addressToCall.read(context).getAsUInt16()
    
    context.registers.SP -= 2
    
    context.memoryAccess.write(context.registers.SP, value: context.registers.PC + 1)
    
    context.registers.PC = address
  }
}