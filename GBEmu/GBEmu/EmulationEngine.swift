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
  
  private var dispatchQueue : dispatch_queue_t!
  
  private let parser = OpcodeParser()
  private var romData : NSData!
  private var executionContext : ExecutionContext
  
  let registers = Registers()
  let memoryAccess = MemoryAccessor()
  var delegate : EmulationEngineDelegate?
  
  var positionCountDict = [UInt16 : (count : Int, flags : UInt8)]()
  
  var shouldBreakAtDetectedLoop : Bool = false {
    didSet {
      positionCountDict = [UInt16 : (count : Int, flags : UInt8)]()
    }
  }
  
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
  
  func beginBackgroundRunning() {
    
    if dispatchQueue == nil { dispatchQueue  =  dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) }
    
    dispatch_async(dispatchQueue) { () -> Void in
      
      while true {
        
        //wird mit 30fps ausgeführt
        //wir wollen einen clock cycle von (1000.0 * 1000.0 * 4.194304) MHz
        var res : (instruction: Instruction, result: InstructionResult, shouldAbortExecution: Bool)
        
        var cycleCount = 0.0
        repeat {
          res = self.executeNextInstruction()
          cycleCount += Double(res.result.usedCycles)
          
          if res.shouldAbortExecution {
            break
          }
        } while cycleCount < (1000.0 * 1000.0 * 4.194304)
        
        if res.shouldAbortExecution {
          break
        }
      }
    }
  }
  
  func executeNextFrame() {
    
    //cycles = clock speed in Hz / required frames-per-second
    // => Anzahl Cycles die 60x pro Sekunde ausgeführt werden müssen
    repeat {
      executeNextInstruction()
    } while executionContext.usedClockCyclesInCurrentFrame != 0
    
  }
  
  func executeNextInstruction() -> (instruction: Instruction, result: InstructionResult, shouldAbortExecution: Bool) {
    
    
    let oldPC = executionContext.registers.PC
    let oldFlags = executionContext.registers.Flags
    
    let retVal = readNextInstruction()
    
    self.registers.PC += retVal.opcodeSize
    
    let result = retVal.instruction.execute(executionContext)
    
    if executionContext.addClockCyclesToFrame(result.usedCycles) {
      //wurde ein neues Frame angefangen?
      self.delegate?.frameCompleted(self)
    }
    
    display.refresh()
    
    if executionContext.interruptMasterEnable && memoryAccess[IORegister.IE.rawValue] > 0 {
      
      let op = PUSH(opcode: 0, locationToWrite: DoubleRegisterLocation(register: .PC))
      
      //aktuellen PC in Stack pushen
      op.execute(executionContext)
      
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
    
    var shouldAbortExecution = false
    
    if shouldBreakAtDetectedLoop {
      if var data = positionCountDict[oldPC] {
        if data.flags == oldFlags {
          data.count += 1
          print("hit position \(oldPC) \(data.count) times with the same flags" )
        }
      } else {
        positionCountDict[oldPC] = (1, oldFlags)
      }
      
      if !positionCountDict.filter({ (pos : UInt16, data : (count: Int, flags: UInt8)) -> Bool in
        data.count == 1000
      }).isEmpty {
        // wir haben einen loop 1000x durchlaufen
        shouldAbortExecution = true
      }
    }
    
    
    return (instruction: retVal.instruction, result: result, shouldAbortExecution: shouldAbortExecution)
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

