//
//  JR.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class JR<T : DataLocation where T.DataSize == UInt8> : Instruction {
  
  let locationToRead : T
  let isRelative : Bool
  let condition : JumpCondition?
  
  override var description : String {
    get {
      var str = "JR "
      
      if let c = condition {
        str += c.description + "? "
      }
      str += locationToRead.description
      return str
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, locationToRead : T, isRelative : Bool = false, condition : JumpCondition? = nil) {
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
    let newAddress = oldAddress + UInt16(newValue)
    context.registers.PC = UInt16(newAddress)
    
    return InstructionResult(opcode: self.opcode)
  }
}

class JP<T : DataLocation where T.DataSize == UInt16> : Instruction {
  
  let locationToRead : T
  let condition : JumpCondition?
  
  override var description : String {
    get {
      var str = "JP "
      
      if let c = condition {
        str += c.description + "? "
      }
      str += locationToRead.description
      return str
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, locationToRead : T, condition : JumpCondition? = nil) {
    self.locationToRead = locationToRead
    self.condition = condition
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    if let cond = condition {
      if !cond.conditionSatisfied(context) {
        return InstructionResult(opcode: self.opcode, executed: false)
      }
    }
    
    let newValue = locationToRead.read(context)
    context.registers.PC = newValue
    
    return InstructionResult(opcode: self.opcode)
  }
}