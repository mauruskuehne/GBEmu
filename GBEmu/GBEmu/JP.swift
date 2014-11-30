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
      switch(cond) {
      case .Zero :
        if !context.registers.Flags.isFlagSet(Flags.Zero) {
          return
        }
      case .NotZero :
        if context.registers.Flags.isFlagSet(Flags.Zero) {
          return
        }
      case .Carry :
        if !context.registers.Flags.isFlagSet(Flags.Carry) {
          return
        }
      case .NotCarry :
        if context.registers.Flags.isFlagSet(Flags.Carry) {
          return
        }
      }
    }
    let oldAddress = context.registers.PC
    let newValue = locationToRead.read(context)
    let newAddress = isRelative ? oldAddress + UInt16(newValue.getAsUInt8()) : newValue.getAsUInt16()
    
    context.registers.PC = newAddress
  }
}