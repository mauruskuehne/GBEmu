//
//  PUSH.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class PUSH<T : DataLocation where T.DataSize == UInt16> : Instruction {
  
  let locToWrite : T
  
  override var description : String {
    get {
      return "PUSH \(locToWrite)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, locationToWrite : T) {
    self.locToWrite = locationToWrite
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    let value = locToWrite.read(context)
    PUSH.pushToStack(context, value: value)
    return InstructionResult(opcode: self.opcode)
  }
  
  class func pushToStack(context : ExecutionContext, value : UInt16) {
    context.registers.SP -= 2
    context.memoryAccess.write(context.registers.SP, value: value)
  }
}