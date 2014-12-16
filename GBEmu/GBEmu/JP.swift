//
//  JR.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class JP : Instruction {
  
  let locationToRead : ReadableDataLocation
  let isRelative : Bool
  let condition : JumpCondition?
  
  override var description : String {
    get {
      var str : String
      
      if isRelative {
        str = "JR "
      } else {
        str = "JP "
      }
      
      if let c = condition {
        str += c.description + "? "
      }
      str += locationToRead.description
      return str
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, locationToRead : ReadableDataLocation, isRelative : Bool = false, condition : JumpCondition? = nil) {
    self.locationToRead = locationToRead
    self.isRelative = isRelative
    self.condition = condition
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    if let cond = condition {
      if !cond.conditionSatisfied(context) {
        return InstructionResult(opcode: self.opcode, executed: false)
      }
    }
    
    let oldAddress = context.registers.PC
    let newValue = locationToRead.read(context)
    if isRelative {
      let newAddress = oldAddress.getAsInt32() + newValue.getAsInt32()
      context.registers.PC = UInt16(newAddress)
    } else {
      context.registers.PC = newValue.getAsUInt16()
    }
    
    return InstructionResult(opcode: self.opcode)
  }
}