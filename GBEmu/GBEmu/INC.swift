//
//  INC.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class INC : Instruction {
  
  let register : Register
  
  override var description : String {
    get {
      return "INC \(register)"
    }
  }
  
  init(register : Register) {
    self.register = register
  }
  
  override func execute(context : ExecutionContext) {
    
    let newVal = (context.registers[register] as UInt16) + 1
    
    context.registers[register] = newVal
    
  }
}
