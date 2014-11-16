//
//  RegisterDataLocation.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RegisterDataLocation : ReadableDataLocation, WriteableDataLocation {
  let register : Register
  let dereferenceFirst : Bool
  
  init(register : Register, dereferenceFirst : Bool = true) {
    self.register = register
    self.dereferenceFirst = dereferenceFirst
  }
  
  func read(context : ExecutionContext) -> DataLocationSupported {
    
    if dereferenceFirst {
      return context.memoryAccess.readUInt16(context.registers[register] as UInt16)
    }
    else {
      return context.registers[register]
    }
  }
  
  func write(value : DataLocationSupported, context : ExecutionContext) {
    if dereferenceFirst {
      let addr = context.registers[register]
      //context.memoryAccess.
      
    }
    else {
      context.registers[register] = value as UInt16
    }
  }
  
  var description: String {
    get {
      return "\(register)"
    }
  }
}