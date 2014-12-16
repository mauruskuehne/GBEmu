//
//  Opcodes.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class Instruction : Printable{
  let opcode : UInt8
  let prefix : UInt8?
  
  var description: String {
    get {
      return "unknown instruction"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil) {
    self.opcode = opcode
    self.prefix = prefix
  }
  
  func execute(context : ExecutionContext) {
    
  }
  
}