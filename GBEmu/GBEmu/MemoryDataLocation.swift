//
//  MemoryDataLocation.swift
//  GBEmu
//
//  Created by Maurus Kühne on 16.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class Fixed8BitMemoryDataLocation : DataLocation {
  typealias DataSize = UInt8
  
  let memoryAddress : UInt16
  
  init(memoryAddress : UInt16) {
    self.memoryAddress = memoryAddress
  }
  
  func read(context : ExecutionContext) -> DataSize {
    return context.memoryAccess.readUInt8(memoryAddress)
  }
  
  var description : String {
    get {
      return String(format: "(0x%X)", memoryAddress)
    }
  }
}

class Fixed16BitMemoryDataLocation : DataLocation {
  typealias DataSize = UInt16
  
  let memoryAddress : UInt16
  
  init(memoryAddress : UInt16) {
    self.memoryAddress = memoryAddress
  }
  
  func read(context : ExecutionContext) -> DataSize {
    return context.memoryAccess.readUInt16(self.memoryAddress)
  }
  
  var description : String {
    get {
      return String(format: "(0x%X)", memoryAddress)
    }
  }
}

/*
enum DataSize {
  case UInt16, UInt8
}

class MemoryDataLocation : ReadWriteDataLocation {
  
  let address : UInt16
  let size : DataSize
  
  init(address : UInt16, size : DataSize) {
    self.address = address
    self.size = size
  }
  
  func read(context : ExecutionContext) -> DataLocationSupported {
    if size == .UInt16 {
      return context.memoryAccess.readUInt16(self.address)
    }
    else {
      return context.memoryAccess.readUInt8(self.address)
    }
  }
  
  func write(value : DataLocationSupported, context : ExecutionContext) {
    if size == .UInt16 {
      let val = value.getAsUInt16()
      let bytes = val.toBytes()
      context.memoryAccess.write(self.address, value: value)
      
    } else {
      context.memoryAccess.memory[Int(address)] = value.getAsUInt8()
    }
  }
  
  var description: String {
    get {
      return String(format: "(0x%X)", address)
    }
  }
}*/