//
//  Flags.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

enum Flags : UInt8 {
  case Zero =       0b10000000
  case Subtract =   0b01000000
  case HalfCarry =  0b00100000
  case Carry =      0b00010000
  
  var description: String {
    get {
      switch(self) {
      case .Zero :
        return "Zero"
      case .Subtract :
        return "Subtract"
      case .Carry :
        return "Carry"
      case .HalfCarry :
        return "HalfCarry"
      }
    }
  }
}