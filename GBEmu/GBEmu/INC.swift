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
  
  init(locToIncrease : ReadWriteDataLocation) {
    self.location = locToIncrease
  }
  
  convenience init(register : Register) {
    self.init(locToIncrease: RegisterDataLocation(register: register, dereferenceFirst: false))
  }
  
  override func execute(context : ExecutionContext) {
    
    let oldVal = location.read(context).getAsUInt16()
    
    let newVal = oldVal + 1
    
    location.write(newVal, context: context)
    
  }
}
