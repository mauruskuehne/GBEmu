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
  
  private let CLOCK_SPEED = 4.194304 * 1000 * 1000
  
  private let parser = OpcodeParser()
  private var romData : NSData!
  private var executionContext : ExecutionContext!
  
  let registers = Registers()
  let memoryAccess = MemoryAccessor()
  var delegate : EmulationEngineDelegate?
  
  //Hardware
  let display : Display
  
  init() {
    self.display = Display(memory: self.memoryAccess)
  }
  
  func loadRom(romData : NSData) {
    self.romData = romData
    self.memoryAccess.loadRom(self.romData)
    
    setupExecution()
    
    delegate?.engineDidLoadRom(self)
  }
  
  private func setupExecution() {
    self.executionContext = ExecutionContext(registers: registers, memoryAccess : memoryAccess)
    
    registers.reset()
    
    self.display.initialize()
  }
  
  func executeNextFrame() {
    
    //cycles = clock speed in Hz / required frames-per-second
    
    let cycles = UInt32( CLOCK_SPEED / 59.73)
    var usedCycles : UInt32 = 0
    
    while usedCycles < cycles {
      
      let retVal = readNextInstruction()
      
      self.registers.PC += retVal.opcodeSize
      
      let result = retVal.instruction.execute(executionContext)
      
      usedCycles += UInt32(result.usedCycles)
      
      display.refresh()
      
      delegate?.executedInstruction(self, instruction: retVal.instruction)
    }
    
  }
  
  func executeNextInstruction() {
    let retVal = readNextInstruction()
    
    self.registers.PC += retVal.opcodeSize
    
    let result = retVal.instruction.execute(executionContext)
    
    display.refresh()
    
    delegate?.executedInstruction(self, instruction: retVal.instruction)
    
  }
  
  func executeToVSync() {
    
    do {
      let retVal = readNextInstruction()
      
      self.registers.PC += retVal.opcodeSize
      
      let result = retVal.instruction.execute(executionContext)
      
      display.refresh()
      
      delegate?.executedInstruction(self, instruction: retVal.instruction)
    } while executionContext.memoryAccess.readUInt8(IORegister.LY.rawValue) != 144
  }
  
  func readNextInstruction() -> (instruction : Instruction, opcodeSize: UInt16) {
    var workingAddress = self.registers.PC
    let firstOpcodeByte =  memoryAccess.readUInt8(workingAddress++)
    
    let instruction = parser.parseInstruction(firstOpcodeByte, fetchNextBytePredicate: {
      return self.memoryAccess.readUInt8(workingAddress++)
    })
    
    let opcodeSize = workingAddress - self.registers.PC
    
    return (instruction, opcodeSize)
  }
}