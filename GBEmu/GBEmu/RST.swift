//
//  RST.swift
//  GBEmu
//
//  Created by Maurus Kühne on 30.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RST : Instruction {
  
  let newPCValue : UInt8
  
  override var description : String {
    get {
      return "RST \(newPCValue)"
    }
  }
  
  init(newPCValue : UInt8 ) {
    self.newPCValue = newPCValue
  }
  
  override func execute(context : ExecutionContext) {
    
    context.registers.SP -= 2
    
    context.memoryAccess.write(context.registers.SP, value: context.registers.PC)
    
    context.registers.PC = newPCValue.getAsUInt16()
  }
}