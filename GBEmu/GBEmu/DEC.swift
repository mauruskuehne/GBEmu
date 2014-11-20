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
  
  
  init(locToDecrease : ReadWriteDataLocation) {
    self.location = locToDecrease
  }
  
  convenience init(register : Register) {
    self.init(locToDecrease: RegisterDataLocation(register: register, dereferenceFirst: false))
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
