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
  
  init(register : Register, dereferenceFirst : Bool = false) {
    self.register = register
    self.dereferenceFirst = dereferenceFirst
    
    
    let bigRegisters = [ Register.HL ]
    
    //if(self.register)
    
    if contains(bigRegisters, self.register) {
      size = .UInt16
    } else {
      size = .UInt8
    }
    
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
    
    if dereferenceFirst {
      let addr = context.registers[register].getAsUInt16()
      context.memoryAccess.write(addr, value: value)
    }
    else {
      context.registers[register] = value
    }
  }
  
  var description: String {
    get {
      if dereferenceFirst {
        return "(\(register.description))"
      }
      else {
        return "\(register.description)"
      }
    }
  }
}