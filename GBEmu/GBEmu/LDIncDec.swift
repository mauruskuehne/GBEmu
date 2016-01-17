//
//  LD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

enum Operation {
  case Inc, Dec
}

enum ModifiedLocation {
  case ReadLocation, WriteLocation
}

class LDIncDec<TRead : DataLocation, TWrite : WriteableDataLocation where TRead.DataSize == TWrite.DataSize> : Instruction {

  
  let readLocation : TRead
  let writeLocation : TWrite
  let operation : Operation
  
  override var description : String {
    get {
      var str : String
      let writeStr = "\(writeLocation.description)"
      let readStr = "\(readLocation.description)"
      if operation == .Inc {
        str = "LDI "
      } else {
        str = "LDD "
      }
      
      return str + writeStr + ", " + readStr
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, readLocation : TRead, writeLocation : TWrite, operation : Operation) {
      
      self.readLocation = readLocation
      self.writeLocation = writeLocation
      self.operation = operation
      super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let val = readLocation.read(context)

    writeLocation.write(val, context: context)
    
    if operation == .Inc {
      context.registers.HL = context.registers.HL &+ 1
    } else {
      context.registers.HL = context.registers.HL &- 1
    }
    
    return InstructionResult(opcode: self.opcode)
  }
}
