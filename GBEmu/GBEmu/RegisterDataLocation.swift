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
  
  
  init(register : Register) {
    self.register = register
  }
  
  func read(context : ExecutionContext) -> DataLocationSupported {
    return context.registers[register]
  }
  
  func write(value : DataLocationSupported, context : ExecutionContext) {
    context.registers[register] = value as UInt16
  }
  
  var description: String {
    get {
      return "\(register)"
    }
  }
}