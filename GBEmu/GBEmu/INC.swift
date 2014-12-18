//
//  INC.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class INC : Instruction {
  
  let location : ReadWriteDataLocation
  
  override var description : String {
    get {
      return "INC \(location)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, locToIncrease : ReadWriteDataLocation) {
    self.location = locToIncrease
    super.init(opcode: opcode, prefix: prefix)
  }
  
  convenience init(opcode : UInt8, prefix : UInt8? = nil, register : Register) {
    self.init(opcode: opcode, prefix: prefix, locToIncrease: RegisterDataLocation(register: register, dereferenceFirst: false))
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let oldVal = location.read(context)
    
    //let newVal = oldVal + 1
    
    let res = ADD.calculateResultForUnsignedAdd(context, oldValue: oldVal, valToAdd: UInt8(1))
    
    location.write(res.result, context: context)
    
    if oldVal is UInt8 {
      context.registers.Flags = res.flags
    }
    
    return InstructionResult(opcode: self.opcode)
  }
}
