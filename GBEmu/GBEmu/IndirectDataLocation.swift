//
//  IndirectDataLocation.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17.01.16.
//  Copyright © 2016 Maurus Kühne. All rights reserved.
//

import Foundation

class Indirect8BitAccessDataLocation<T : DataLocation where T.DataSize == UInt16> : DataLocation {
  typealias DataSize = UInt8
  
  let addressLocation : T
  
  init(addressLocation: T) {
    self.addressLocation = addressLocation
  }
  
  func read(context : ExecutionContext) -> DataSize {
    let addr = addressLocation.read(context)
    return context.memoryAccess.readUInt8(addr)
  }
  
  var description : String {
    get {
      return "(\(addressLocation.description))"
    }
  }
}

class Indirect16BitAccessDataLocation<T : DataLocation where T.DataSize == UInt16> : DataLocation {
  typealias DataSize = UInt16
  
  let addressLocation : T
  
  init(addressLocation: T) {
    self.addressLocation = addressLocation
  }
  
  func read(context : ExecutionContext) -> DataSize {
    let addr = addressLocation.read(context)
    return context.memoryAccess.readUInt16(addr)
  }
  
  var description : String {
    get {
      return "(\(addressLocation.description))"
    }
  }
}
