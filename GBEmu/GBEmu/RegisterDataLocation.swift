//
//  RegisterDataLocation.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

private struct BigRegisterContainer {
  static let bigRegisters = [ Register.HL, Register.AF, Register.BC, Register.DE, Register.PC, Register.SP ]
}

class RegisterDataLocation : ReadWriteDataLocation {
  
  let register : Register
  let dereferenceFirst : Bool
  let size : DataSize
  let offset : Int32?
  
  init(register : Register, dereferenceFirst : Bool = false, offset : Int32? = nil) {
    self.register = register
    self.dereferenceFirst = dereferenceFirst
    self.offset = offset
    
    
    
    //if(self.register)
    
    if BigRegisterContainer.bigRegisters.contains(self.register) {
      size = .UInt16
    } else {
      size = .UInt8
    }
    
  }
  
  func read(context : ExecutionContext) -> DataLocationSupported {
    
    if dereferenceFirst {
      /*if size == DataSize.UInt16 {
        return context.memoryAccess.readUInt16(context.registers[register].getAsUInt16())
      }
      else {*/
        return context.memoryAccess.readUInt8(context.registers[register].getAsUInt16())
      //}
    }
    else {
      //size ist egal, wir geben immer das ganze Register zurück
      return context.registers[register]
      
    }
  }
  
  func write(value : DataLocationSupported, context : ExecutionContext) {
    
    if dereferenceFirst {
      if let memOffset = offset {
        let addr = UInt16(memOffset + Int32(context.registers[register].getAsUInt16()))
        context.memoryAccess.write(addr, value: value)
      } else {
        let addr = context.registers[register].getAsUInt16()
        context.memoryAccess.write(addr, value: value)
      }
    }
    else {
      
      if let memOffset = offset {
        
        let addr = UInt16(memOffset + Int32(context.registers[register].getAsUInt16()))
        
        context.memoryAccess.write(addr, value: value)
      } else {
        context.registers[register] = value
      }
    }
  }
  
  var description: String {
    get {
      var str = register.description
      
      if let o = offset {
        str = String(format: "0x%X", o) + "+" + str
      }
      
      if dereferenceFirst {
        str = "(" + str + ")"
      }
      return str
    }
  }
}