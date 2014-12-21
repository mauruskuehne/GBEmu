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
    self.memory = [UInt8](count: 0xFFFF, repeatedValue: 0)
  }
  
  func loadRom(rom : NSData) {
    self.rom = rom
    rom.getBytes(&self.memory, length: 0x4000)
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
      if let ioreg = IORegister(rawValue: value.getAsUInt16()) {
        println("the address that is about to be written to is an IO Register")
      }
    }
    
    if(value is UInt16) {
      let bytes = (value as UInt16).toBytes()
      memory[Int(address)] = bytes.lower
      memory[Int(address) + 1] = bytes.upper
    }
    else {
      memory[Int(address)] = value as UInt8
    }
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