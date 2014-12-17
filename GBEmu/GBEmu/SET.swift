//
//  BIT.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SET : RotateInstruction {
  
  let register : ReadWriteDataLocation
  let bitPosition : UInt8
  
  override var description : String {
    get {
      return "SET  \(bitPosition), \(register.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, register : ReadWriteDataLocation, bitPosition : UInt8) {
    self.register = register
    self.bitPosition = bitPosition
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {

    let mask = 1 << bitPosition
    let oldVal = register.read(context).getAsUInt8()
    let newVal = oldVal | mask
    
    register.write(newVal, context: context)
    
    return InstructionResult(opcode: self.opcode)
  }
}