//
//  EmulationEngine.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

struct EmulationEngineContainer {
  static let sharedEngine = EmulationEngine()
}

class EmulationEngine {
  
  let parser : OpcodeParser
  var romData : NSData!
  var registers : Registers!
  var executionContext : ExecutionContext!
  var memoryAccess : MemoryAccessor!
  
  var delegate : EmulationEngineDelegate?
  
  init() {
    parser = OpcodeParser()
  }
  
  func loadRom(romData : NSData) {
    self.romData = romData
    
    setupExecution()
    
    delegate?.engineDidLoadRom(self)
  }
  
  private func setupExecution() {
    self.registers = Registers()
    self.memoryAccess = MemoryAccessor(rom: self.romData)
    self.executionContext = ExecutionContext(registers: registers, memoryAccess : memoryAccess)
  }
  
  func executeNextStep() {
    
    var workingAddress = self.registers.PC
    let firstOpcodeByte =  memoryAccess.readUInt8(workingAddress++)
    
    let instruction = parser.parseInstruction(firstOpcodeByte, fetchNextBytePredicate: {
      return self.memoryAccess.readUInt8(workingAddress++)
    })
    
    self.registers.PC = workingAddress
    
    instruction.execute(executionContext)
    
    delegate?.executedInstruction(self, instruction: instruction)
  }
  
}