//
//  MemoryDataLocation.swift
//  GBEmu
//
//  Created by Maurus Kühne on 16.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

enum DataSize {
  case UInt16, UInt8
}

class MemoryDataLocation : ReadableDataLocation, WriteableDataLocation {
  
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
      let val = UInt16(value)
      let bytes = val.toBytes()
      context.memoryAccess[address] = bytes.lowerByte
      context.memoryAccess[address] = bytes.upperByte
      
    } else {
      context.memoryAccess.memory[address] = value
    }
  }
  
  var description: String {
    get {
      return "(\(address))"
    }
  }
}