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

extension UInt8 : DataLocationSupported {
  
  func getAsUInt8() -> UInt8 {
    return self
  }
  func getAsSInt8() -> sint8 {
    return sint8(bitPattern: self)
  }
  
  func getAsUInt16() -> UInt16 {
    return UInt16(self)
  }
  
  var isSigned : Bool {
    get { return false }
  }
}

extension sint8 : DataLocationSupported {
  
  func getAsUInt8() -> UInt8 {
    return UInt8(bitPattern: self)
  }
  func getAsSInt8() -> sint8 {
    return self
  }
  
  func getAsUInt16() -> UInt16 {
    return UInt16(self)
  }
  
  var isSigned : Bool {
    get { return true }
  }
}

extension UInt16 : DataLocationSupported {
  func getAsUInt8() -> UInt8 {
    return self.toBytes().lower
  }
  
  func getAsSInt8() -> sint8 {
    return sint8(bitPattern: self.getAsUInt8())
  }
  
  func getAsUInt16() -> UInt16 {
    return self
    
  }
  
  var isSigned : Bool {
    get { return false }
  }
}