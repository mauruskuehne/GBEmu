//
//  DEC.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class DEC : Instruction {
  
  let location : ReadWriteDataLocation
  
  override var description : String {
    get {
      return "DEC \(location)"
    }
  }
  
  
  init(opcode : UInt8, prefix : UInt8? = nil, locToDecrease : ReadWriteDataLocation) {
    self.location = locToDecrease
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  convenience init(opcode : UInt8, prefix : UInt8? = nil, register : Register) {
    self.init(opcode: opcode, prefix: prefix, locToDecrease: RegisterDataLocation(register: register, dereferenceFirst: false))
  }
  
  override func execute(context : ExecutionContext) {
    
    let oldVal = location.read(context)
    
    if oldVal is UInt16 {
      location.write(oldVal.getAsUInt16() - 1, context: context)
    } else {
      location.write(oldVal.getAsUInt8() - 1, context: context)
    }
    
  }
}
