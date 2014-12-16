//
//  EmulationContext.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class ExecutionContext  {
  let registers : Registers
  let memoryAccess : MemoryAccessor
  
  init(registers : Registers, memoryAccess : MemoryAccessor) {
    self.registers = registers;
    self.memoryAccess = memoryAccess
  }
}