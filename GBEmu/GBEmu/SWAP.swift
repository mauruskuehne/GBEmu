//
//  SWAP.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SWAP : Instruction {
  let register : ReadWriteDataLocation
  
  override var description : String {
    get {
      return "SWAP \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : ReadWriteDataLocation) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let val = register.read(context).getAsUInt8()
    
    let newVal = (val << 4) + (val >> 4)
    
    register.write(newVal, context: context)
    
    return InstructionResult(opcode: self.opcode)
  }
}