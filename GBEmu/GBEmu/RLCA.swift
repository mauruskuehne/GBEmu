//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RLCA : Instruction {
  
  override var description : String {
    get {
      return "RLCA"
    }
  }
  
  override func execute(context : ExecutionContext) {
    
    let newVal = context.registers.A << 1;
    
    let lastBit = context.registers.A & 0b1000_0000
    
    if lastBit > 0 {
      context.registers.A = newVal | 1
    } else {
      context.registers.A = newVal
    }
    
    context.registers.Flags.resetFlag(.HalfCarry)
    context.registers.Flags.resetFlag(.Subtract)
  }
}