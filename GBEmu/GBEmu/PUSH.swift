//
//  PUSH.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class PUSH : Instruction {
  
  let locToWrite : ReadableDataLocation
  
  override var description : String {
    get {
      return "PUSH \(locToWrite)"
    }
  }
  
  init(locationToWrite : ReadableDataLocation) {
    self.locToWrite = locationToWrite
  }
  
  override func execute(context : ExecutionContext) {
    
    context.registers.SP -= 2
    
    let value = locToWrite.read(context)
    
    context.memoryAccess.write(context.registers.SP, value: value)
  }
}