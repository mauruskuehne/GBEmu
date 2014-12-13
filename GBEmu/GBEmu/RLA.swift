//
//  DI.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RLA : RotateInstruction {
  
  override var description : String {
    get {
      return "RLA"
    }
  }
  
  override func execute(context : ExecutionContext) {
    
    let newVal = context.registers.A << 1;
    
    let lastBit = context.registers.A & 0b1000_0000
    
    if context.registers.Flags.isFlagSet(.Carry) {
      context.registers.A |= 0b0000_0001
    }
    
    if lastBit > 0 {
      context.registers.Flags.setFlag(.Carry)
    } else {
      context.registers.Flags.resetFlag(.Carry)
    }
    
    context.registers.Flags.resetFlag(.HalfCarry)
    context.registers.Flags.resetFlag(.Subtract)
  }
}