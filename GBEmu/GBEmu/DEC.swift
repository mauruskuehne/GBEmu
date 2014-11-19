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
  
  
  init(locToIncrease : ReadWriteDataLocation) {
    self.location = locToIncrease
  }
  
  convenience init(register : Register, size : DataSize) {
    self.init(locToIncrease: RegisterDataLocation(register: register, dereferenceFirst: false, size: size))
  }
  
  override func execute(context : ExecutionContext) {
    
    let newVal = location.read(context) as UInt16 - 1
    
    location.write(newVal, context: context)
    
  }
}
