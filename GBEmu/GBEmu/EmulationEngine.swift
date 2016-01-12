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
  
  private let parser = OpcodeParser()
  private var romData : NSData!
  private var executionContext : ExecutionContext
  
  let registers = Registers()
  let memoryAccess = MemoryAccessor()
  var delegate : EmulationEngineDelegate?
  
  //Hardware
  let display : Display
  
  init() {
    self.executionContext = ExecutionContext(registers: registers, memoryAccess : memoryAccess)
    self.display = Display(context: self.executionContext)
  }
  
  func loadRom(romData : NSData) {
    self.romData = romData
    self.memoryAccess.loadRom(self.romData)
    
    setupExecution()
    
    delegate?.engineDidLoadRom(self)
  }
  
  private func setupExecution() {
    
    registers.reset()
    
    self.display.initialize()
  }
  
  func executeNextFrame() {
    
    //cycles = clock speed in Hz / required frames-per-second
    // => Anzahl Cycles die 60x pro Sekunde ausgeführt werden müssen
    repeat {
      let executedInstruction = executeNextInstruction()
    } while executionContext.usedClockCyclesInCurrentFrame != 0
    
  }
  
  func executeNextInstruction() -> (instruction : Instruction, result: InstructionResult) {
    let retVal = readNextInstruction()
    
    self.registers.PC += retVal.opcodeSize
    
    let result = retVal.instruction.execute(executionContext)
    
    if executionContext.addClockCyclesToFrame(result.usedCycles) {
      //wurde ein neues Frame angefangen?
      self.delegate?.frameCompleted(self)
    }
    
    display.refresh()
    
    if executionContext.interruptMasterEnable && memoryAccess[IORegister.IE.rawValue] > 0 {
      
      //aktuellen PC in Stack pushen
      PUSH.pushToStack(executionContext, value: registers.PC)
      
      //PC auf korrekte Adresse setzen
      func isInterruptRequested(interrupt: InterruptFlag) -> Bool {
        return (memoryAccess[IORegister.IE.rawValue] & interrupt.rawValue > 0) && (memoryAccess[IORegister.IF.rawValue] & interrupt.rawValue > 0)
      }
      
      if isInterruptRequested(.VBlank) {
        print("VBlank Interrupt")
        executionContext.registers.PC = 0x0040
        memoryAccess[IORegister.IF.rawValue] &= ~InterruptFlag.VBlank.rawValue
        
      } else if isInterruptRequested(.LCDC) {
        print("LCDC Interrupt")
        executionContext.registers.PC = 0x0048
        memoryAccess[IORegister.IF.rawValue] &= ~InterruptFlag.LCDC.rawValue
        
      } else if isInterruptRequested(.Timer_Overflow) {
        print("Timer_Overflow Interrupt")
        executionContext.registers.PC = 0x0050
        memoryAccess[IORegister.IF.rawValue] &= ~InterruptFlag.Timer_Overflow.rawValue
        
      } else if isInterruptRequested(.Serial_Transfer_Complete) {
        print("Serial_Transfer_Complete Interrupt")
        executionContext.registers.PC = 0x0058
        memoryAccess[IORegister.IF.rawValue] &= ~InterruptFlag.Serial_Transfer_Complete.rawValue
        
      } else if isInterruptRequested(.PIN_Hi_Lo_Change) {
        print("PIN_Hi_Lo_Change Interrupt")
        executionContext.registers.PC = 0x0060
        memoryAccess[IORegister.IF.rawValue] &= ~InterruptFlag.PIN_Hi_Lo_Change.rawValue
        
      }
      
      //Interrupts deaktivieren
      executionContext.interruptMasterEnable = false
    }
    
    delegate?.executedInstruction(self, instruction: retVal.instruction)
    
    return (instruction: retVal.instruction, result: result)
  }
  
  func executeToVSync() {
    repeat {
      executeNextInstruction()
    } while executionContext.memoryAccess.readUInt8(IORegister.LY.rawValue) != 144
  }
  
  func executeToRet() {
    var res : Instruction!
    repeat {
      res = executeNextInstruction().instruction
    } while !(res is RET)
  }
  
  func executeToAddress(address : UInt16) {
    repeat {
      executeNextInstruction()
    } while registers.PC != address
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

