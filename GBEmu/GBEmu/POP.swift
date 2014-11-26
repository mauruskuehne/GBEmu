//
//  POP.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class POP : Instruction {
  
  let locToStore : WriteableDataLocation
  
  override var description : String {
    get {
      return "POP \(locToStore)"
    }
  }
  
  init(locationToStore : WriteableDataLocation) {
    self.locToStore = locationToStore
  }
  
  override func execute(context : ExecutionContext) {
    
    let value = context.memoryAccess.readUInt16(context.registers.SP)
    
    context.registers.SP += 2
    
    locToStore.write(value, context: context)
  }
}