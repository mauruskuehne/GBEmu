//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RRCA : RotateInstruction {
  
  override var description : String {
    get {
      return "RRCA"
    }
  }
  
  override func execute(context : ExecutionContext) {
    
    let newVal = context.registers.A >> 1;
    
    let firstBit = context.registers.A & 0b0000_0001
    
    if firstBit > 0 {
      context.registers.A = newVal | 0b1000_0000
    } else {
      context.registers.A = newVal
    }
    
    context.registers.Flags.resetFlag(.HalfCarry)
    context.registers.Flags.resetFlag(.Subtract)
  }
}