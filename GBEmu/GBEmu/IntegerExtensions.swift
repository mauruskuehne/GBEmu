//
//  UInt16Extensions.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

extension UInt16 {
  
  static func fromUpperByte(byte : UInt8, lowerByte : UInt8) -> UInt16 {
    return (UInt16(byte) << 8) + UInt16(lowerByte);
  }
  
  func toBytes() -> (upper : UInt8, lower : UInt8) {
    
    let upper = UInt8((self & 0xFF00) >> 8)
    let lower = UInt8(self & 0x00FF)
    
    return (upper,lower)
  }
}

extension UInt8 {
  mutating func setFlag(flag : Flags) {
    self = self | flag.rawValue
  }
  
  mutating func resetFlag(flag : Flags) {
    self = self & ~flag.rawValue
  }
  
  func isFlagSet(flag : Flags) -> Bool {
    return (self & flag.rawValue) > 0
  }
}