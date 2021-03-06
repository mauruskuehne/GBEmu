//
//  MemoryAccessor.swift
//  GBEmu
//
//  Created by Maurus Kühne on 16.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class MemoryAccessor {
  var rom : NSData!
  var memory : [UInt8]
  
  init() {
    self.memory = [UInt8](count: 0x10000, repeatedValue: 0)
  }
  
  func loadRom(rom : NSData) {
    self.rom = rom
    //we currently only support 32KByte ROMs
    rom.getBytes(&self.memory, length: 0x8000)
  }
  
  func readUInt8(address : UInt16) -> UInt8 {
    /*
    if let ioreg = IORegister(rawValue: address) {
      println("the address that is about to be read to is an IO Register")
    }*/
    
    return self.memory[Int(address)]
  }
  
  func readUInt16(address : UInt16) -> UInt16 {
    let b1 = readUInt8(address)
    let b2 = readUInt8(address + 1)
    return UInt16.fromUpperByte(b2, lowerByte: b1)
  }
  
  func write(address : UInt16, value : DataLocationSupported) {
    
    if value is UInt16 {
      if let _ = IORegister(rawValue: value.getAsUInt16()) {
        print("the address that is about to be written to is an IO Register")
      }
    }
    
    if(value is UInt16) {
      let bytes = (value as! UInt16).toBytes()
      memory[Int(address)] = bytes.lower
      memory[Int(address) + 1] = bytes.upper
    }
    else {
      memory[Int(address)] = value as! UInt8
    }
  }
  
  func getRange(address : UInt16, length : UInt16) -> [UInt8] {
    let val = self.memory[Int(address)...Int(address + length)]
    return Array(val)
  }
  
  subscript(index: UInt16) -> UInt8 {
    get {
      return readUInt8(index)
    }
    set(newValue) {
      write(index, value: newValue)
    }
  }
}