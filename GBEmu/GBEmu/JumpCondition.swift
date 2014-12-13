//
//  JumpCondition.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.12.14.
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
  
  var description: String {
    get {
      switch(self) {
      case .Zero :
        return "Zero"
      case .NotZero :
        return "NotZero"
      case .Carry :
        return "Carry"
      case .NotCarry :
        return "NotCarry"
      }
    }
  }
}