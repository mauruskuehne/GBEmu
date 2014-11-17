//
//  MemoryAccessor.swift
//  GBEmu
//
//  Created by Maurus Kühne on 16.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class MemoryAccessor {
  let rom : NSData
  var memory : [UInt8]
  
  init(rom : NSData) {
    self.rom = rom
    
    self.memory = [UInt8](count: 0xFFFF, repeatedValue: 0)
    rom.getBytes(&self.memory, length: 0x4000)
  }
  
  func readUInt8(address : UInt16) -> UInt8 {
    return self.memory[Int(address)]
  }
  
  func readUInt16(address : UInt16) -> UInt16 {
    
    let b1 = readUInt8(address)
    let b2 = readUInt8(address + 1)
    return UInt16.fromUpperByte(b1, lowerByte: b2)
  }
  
  func write(address : UInt16, value : DataLocationSupported) {
    
    if(value is UInt16)
    {
      let bytes = (value as UInt16).toBytes()
      memory[Int(address)] = bytes.lower
      memory[Int(address) + 1] = bytes.upper
    }
    else {
      memory[Int(address)] = value as UInt8
    }
  }
}