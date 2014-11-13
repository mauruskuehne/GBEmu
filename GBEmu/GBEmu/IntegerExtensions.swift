//
//  UInt16Extensions.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

extension UInt16 {
  
  static func fromUpperByte(byte : Byte, lowerByte : Byte) -> UInt16 {
    return (UInt16(byte) << 8) + UInt16(lowerByte);
  }
  
  func toBytes() -> (upper : Byte, lower : Byte) {
    
    let upper = Byte((self & 0xFF00) >> 8)
    let lower = Byte(self & 0x00FF)
    
    return (upper,lower)
  }
  
}

extension Byte {
  mutating func setFlag(flag : Flags) {
    self = self | flag.rawValue
  }
  
  mutating func resetFlag(flag : Flags) {
    self = self & ~flag.rawValue
  }
  
  func isFlagSet(flag : Flags) -> BooleanType{
    return (self & flag.rawValue) > 0
  }
}