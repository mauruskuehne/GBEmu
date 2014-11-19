//
//  RegisterDataLocation.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class RegisterDataLocation : ReadWriteDataLocation {
  let register : Register
  let dereferenceFirst : Bool
  let size : DataSize
  
  init(register : Register, dereferenceFirst : Bool = true, size : DataSize = DataSize.UInt8) {
    self.register = register
    self.dereferenceFirst = dereferenceFirst
    self.size = size
  }
  
  func read(context : ExecutionContext) -> DataLocationSupported {
    
    if dereferenceFirst {
      if size == DataSize.UInt16 {
        return context.memoryAccess.readUInt16(context.registers[register] as UInt16)
      }
      else {
        return context.memoryAccess.readUInt8(context.registers[register] as UInt16)
      }
    }
    else {
      //size ist egal, wir geben immer das ganze Register zurück
      return context.registers[register]
      
    }
  }
  
  func write(value : DataLocationSupported, context : ExecutionContext) {
    assertionFailure("not yet implemented")
    
    if dereferenceFirst {
      let addr = context.registers[register] as UInt16
      context.memoryAccess.write(addr, value: value)
    }
    else {
      let val = value as UInt16
      if self.size == .UInt16 {
        context.registers[register] = value as UInt16
      } else {
        
      }
      
    }
  }
  
  var description: String {
    get {
      return "\(register)"
    }
  }
}