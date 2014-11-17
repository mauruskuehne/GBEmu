//
//  DEC.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class DEC : Instruction {
  
  let register : Register
  
  override var description : String {
    get {
      return "DEC \(register)"
    }
  }
  
  init(register : Register) {
    self.register = register
  }
  
  override func execute(context : ExecutionContext) {
    
    let newVal = (context.registers[register] as UInt16) - 1
    
    context.registers[register] = newVal
    
  }
}
