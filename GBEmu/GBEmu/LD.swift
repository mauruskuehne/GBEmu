//
//  LD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class LD<TRead : DataLocation, TWrite : WriteableDataLocation where TRead.DataSize == TWrite.DataSize> : Instruction {
  
  let readLocation : TRead
  let writeLocation : TWrite
  
  override var description : String {
    get {
      return "LD \(writeLocation.description), \(readLocation.description)"
    }
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, readLocation : TRead,
    writeLocation : TWrite) {
      
      self.readLocation = readLocation
      self.writeLocation = writeLocation
      super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {
    
    let val = readLocation.read(context)

    writeLocation.write(val, context: context)
    
    return InstructionResult(opcode: self.opcode)
  }
}
