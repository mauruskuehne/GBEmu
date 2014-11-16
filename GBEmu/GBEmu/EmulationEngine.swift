//
//  EmulationEngine.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class EmulationEngine {
  
  var romData : NSData!
  var registers : Registers!
  var executionContext : ExecutionContext!
  var memoryAccess : MemoryAccessor!
  
  init() {
    
  }
  
  func loadRom(romData : NSData) {
    self.romData = romData
  }
  
  func setupExecution() {
    self.registers = Registers()
    self.memoryAccess = MemoryAccessor(rom: self.romData)
    self.executionContext = ExecutionContext(registers: registers, memoryAccess : memoryAccess)
  }
  
  func executeNextStep() {
    
    let instruction = parseInstruction()
  }
  
  private func parseInstruction() -> Instruction {
    
    let r = [0 : RegisterDataLocation(register: Register.B),
             1 : RegisterDataLocation(register: Register.C),
             2 : RegisterDataLocation(register: Register.D),
             3 : RegisterDataLocation(register: Register.E),
             4 : RegisterDataLocation(register: Register.H),
             5 : RegisterDataLocation(register: Register.L),
             6 : RegisterDataLocation(register: Register.C),
             7 : RegisterDataLocation(register: Register.A)]
    
    let rp = [0 : RegisterDataLocation(register: Register.BC),
              1 : RegisterDataLocation(register: Register.DE),
              2 : RegisterDataLocation(register: Register.HL),
              3 : RegisterDataLocation(register: Register.SP)]
    
    let rp2 = [0 : RegisterDataLocation(register: Register.BC),
              1 : RegisterDataLocation(register: Register.DE),
              2 : RegisterDataLocation(register: Register.HL),
              3 : RegisterDataLocation(register: Register.AF)]
    
    var parsedInstruction : Instruction!
    
    var workingAddress = self.registers.PC
    let firstOpcodeByte =  memoryAccess.readUInt8(workingAddress++)
    
    
    let x = firstOpcodeByte & 0b11000000
    let y = firstOpcodeByte & 0b00111000
    let z = firstOpcodeByte & 0b00000111
    let p = firstOpcodeByte & 0b00110000
    let q = firstOpcodeByte & 0b00001000
    
    switch(x) {
    case 0 :
      switch(z) {
      case 0 :
        switch(y) {
        case 0 :
          parsedInstruction = NOP()
        case 1 :
          assertionFailure("unknown value for y in opcode!")
        case 2 :
          assertionFailure("unknown value for y in opcode!")
        case 3 :
          assertionFailure("unknown value for y in opcode!")
        default :
          assertionFailure("unknown value for y in opcode!")
        }
      case 1 :
        if q == 0 {
          //LD RP[p], nn
          let writeAddr = rp[Int(p)]!
          let valueToLoad = memoryAccess.readUInt16(workingAddress)
          workingAddress += 2
          let constRead = ConstantDataLocation(value: valueToLoad)
          parsedInstruction = LD(readLocation: constRead, writeLocation: writeAddr)
        }
        else {
          //ADD HL, rp[p]
        }
      case 2 :
        
        var readAddr : DataLocationBase
        var writeAddr : DataLocationBase
        
        if q == 0 {
          if p == 0 {
            readAddr = r[7]!
            
          } else if p == 1 {
            readAddr = r[7]!
            writeAddr = rp[1]!
            
          } else if p == 2 {
            let address = memoryAccess.readUInt16(workingAddress)
            workingAddress += 2
            writeAddr = MemoryDataLocation(address: address, size: .UInt16)
            readAddr = rp[2]!
            
          } else if p == 3 {
            let address = memoryAccess.readUInt16(workingAddress)
            workingAddress += 2
            writeAddr = MemoryDataLocation(address: address, size: .UInt16)
            readAddr = r[7]!
            
          }
        }
        else { //q == 1
          if p == 0 {
            writeddr = r[7]!
            
            
          } else if p == 1 {
            writeddr = r[7]!
            
          } else if p == 2 {
            writeAddr = rp[2]!
            
          } else if p == 3 {
            writeddr = r[7]!
            
          }
        }
      case 3 :
        assertionFailure("unknown value for z in opcode!")
      case 4 :
        assertionFailure("unknown value for z in opcode!")
      case 5 :
        assertionFailure("unknown value for z in opcode!")
      case 6 :
        assertionFailure("unknown value for z in opcode!")
      case 7 :
        assertionFailure("unknown value for z in opcode!")
      default :
        assertionFailure("unknown value for z in opcode!")
      }
    case 1 :
      assertionFailure("unknown value for x in opcode!")
    case 2 :
      assertionFailure("unknown value for x in opcode!")
    default :
      assertionFailure("unknown value for x in opcode!")
    }
    
    if parsedInstruction == nil {
      parsedInstruction = Instruction()
    }
    
    return parsedInstruction
  }
  
}