//
//  SWAP.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SWAP<T : WriteableDataLocation where T.DataSize == UInt8> : Instruction {
  let register : T
  
  override var description : String {
    get {
      return "SWAP \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : T) {
    self.register = register
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let val = register.read(context)
    
    let newVal = (val << 4) + (val >> 4)
    
    register.write(newVal, context: context)
    
    return InstructionResult(opcode: self.opcode)
  }
}