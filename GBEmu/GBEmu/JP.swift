//
//  JR.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

enum JumpCondition {
  case Zero, NotZero, Carry, NotCarry
  
  func conditionSatisfied(context : ExecutionContext) -> Bool {
    switch(self) {
    case .Zero :
      if !context.registers.Flags.isFlagSet(Flags.Zero) {
        return false
      }
    case .NotZero :
      if context.registers.Flags.isFlagSet(Flags.Zero) {
        return false
      }
    case .Carry :
      if !context.registers.Flags.isFlagSet(Flags.Carry) {
        return false
      }
    case .NotCarry :
      if context.registers.Flags.isFlagSet(Flags.Carry) {
        return false
      }
    }
    
    return true
  }
}

class JP : Instruction {
  
  let locationToRead : ReadableDataLocation
  let isRelative : Bool
  let condition : JumpCondition?
  
  override var description : String {
    get {
      return "JP \(locationToRead)"
    }
  }
  
  init(locationToRead : ReadableDataLocation, isRelative : Bool = false, condition : JumpCondition? = nil) {
    self.locationToRead = locationToRead
    self.isRelative = isRelative
    self.condition = condition
  }
  
  override func execute(context : ExecutionContext) {
    
    if let cond = condition {
      if !cond.conditionSatisfied(context) {
        return
      }
    }
    
    let oldAddress = context.registers.PC
    let newValue = locationToRead.read(context)
    if isRelative {
      let newAddress = oldAddress.getAsInt32() + newValue.getAsInt32()
      context.registers.PC = UInt16(newAddress)
    } else {
      context.registers.PC = newValue.getAsUInt16()
    }
  }
}