//
//  DEC.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class DEC<TLocation : DataLocation> : Instruction {
  
  let location : TLocation
  
  override var description : String {
    get {
      return "DEC \(location)"
    }
  }
  
  
  init(opcode : UInt8, prefix : UInt8? = nil, locToDecrease : TLocation) {
    self.location = locToDecrease
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let oldVal = location.read(context)
    
    let res = SUB.calculateResultForUnsignedSub(context, oldValue: oldVal, valToSub: 1)
    
    location.write(res.result, context: context)
    
    if oldVal is UInt8 {
      context.registers.Flags = res.flags
    }
    
    return InstructionResult(opcode: self.opcode)
  }
}
