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
    
    let rp = [0 : Register.BC,
              1 : Register.DE,
              2 : Register.HL,
              3 : Register.SP]
    
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
      case 1 : //x = 0, z = 1
        if q == 0 {
          //LD RP[p], nn
          let reg = rp[Int(p)]!
          let writeAddr = RegisterDataLocation(register: reg)
          let valueToLoad = memoryAccess.readUInt16(workingAddress)
          workingAddress += 2
          let constRead = ConstantDataLocation(value: valueToLoad)
          parsedInstruction = LD(readLocation: constRead, writeLocation: writeAddr)
        }
        else {
          //ADD HL, rp[p]
        }
      case 2 : // z = 2
        
        var readAddr : ReadableDataLocation!
        var writeAddr : WriteableDataLocation!
        
        if q == 0 {
          if p == 0 {
            readAddr = r[7]!
            writeAddr = RegisterDataLocation(register: Register.BC, dereferenceFirst: true, size: DataSize.UInt16)
            
          } else if p == 1 {
            readAddr = r[7]!
            writeAddr = RegisterDataLocation(register: Register.DE, dereferenceFirst: true, size: DataSize.UInt16)
            
          } else if p == 2 {
            let address = memoryAccess.readUInt16(workingAddress)
            workingAddress += 2
            writeAddr = MemoryDataLocation(address: address, size: .UInt16)
            readAddr = RegisterDataLocation(register: Register.HL, dereferenceFirst: true, size: DataSize.UInt16)
            
          } else if p == 3 {
            let address = memoryAccess.readUInt16(workingAddress)
            workingAddress += 2
            writeAddr = MemoryDataLocation(address: address, size: .UInt16)
            readAddr = RegisterDataLocation(register: Register.HL, dereferenceFirst: true, size: DataSize.UInt8)
            
          }
        }
        else { //q == 1
          if p == 0 {
            writeAddr = r[7]!
            readAddr = RegisterDataLocation(register: Register.BC, dereferenceFirst: true, size: DataSize.UInt8)
            
          } else if p == 1 {
            writeAddr = r[7]!
            readAddr = RegisterDataLocation(register: Register.DE, dereferenceFirst: true, size: DataSize.UInt8)
            
          } else if p == 2 {
            writeAddr = RegisterDataLocation(register: rp[2]!)
            let address = memoryAccess.readUInt16(workingAddress)
            workingAddress += 2
            readAddr = MemoryDataLocation(address: address, size: .UInt16)
            
            
          } else if p == 3 {
            writeAddr = r[7]!
            let address = memoryAccess.readUInt16(workingAddress)
            workingAddress += 2
            readAddr = MemoryDataLocation(address: address, size: .UInt16)
            
          }
        }
        
        parsedInstruction = LD(readLocation: readAddr, writeLocation: writeAddr)
        
      case 3 :
        if q == 0 { // 16Bit INC
          let reg = rp[Int(p)]!
          parsedInstruction = INC(register: reg)
          
        } else { // 16Bit DEC
          
        }
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