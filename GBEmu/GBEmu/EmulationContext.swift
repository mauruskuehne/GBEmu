//
//  EmulationContext.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class EmulationContext  {
  let registers : Registers
  
  init(registers : Registers) {
    self.registers = registers;
  }
}