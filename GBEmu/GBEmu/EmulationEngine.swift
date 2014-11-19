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
    
    let registerIndexDict =
    [0 : Register.B,
     1 : Register.C,
     2 : Register.D,
     3 : Register.E,
     4 : Register.H,
     5 : Register.L,
     6 : Register.HL,
     7 : Register.A]
    
    
    func getDataLocationFor(idx : Int) -> ReadWriteDataLocation {
      let register = registerIndexDict[idx]!
      
      if register == .HL {
        return RegisterDataLocation(register: register, dereferenceFirst: true)
      } else {
        return RegisterDataLocation(register: register)
      }
    }
    
    let rp = [0 : Register.BC,
              1 : Register.DE,
              2 : Register.HL,
              3 : Register.SP]
    
    let rp2 = [0 : Register.BC,
               1 : Register.DE,
               2 : Register.HL,
               3 : Register.AF]
    
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
          
          //MISSING OPCODE
          
          assertionFailure("unknown value for y in opcode!")
        case 2 :
          
          //MISSING OPCODE
          
          assertionFailure("unknown value for y in opcode!")
        case 3 :
          
          //MISSING OPCODE
          
          assertionFailure("unknown value for y in opcode!")
        default :
          
          //MISSING OPCODE
          
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
            readAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            writeAddr = RegisterDataLocation(register: Register.BC, dereferenceFirst: true, size: DataSize.UInt16)
            
          } else if p == 1 {
            readAddr = RegisterDataLocation(register: registerIndexDict[7]!)
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
            writeAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            readAddr = RegisterDataLocation(register: Register.BC, dereferenceFirst: true, size: DataSize.UInt8)
            
          } else if p == 1 {
            writeAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            readAddr = RegisterDataLocation(register: Register.DE, dereferenceFirst: true, size: DataSize.UInt8)
            
          } else if p == 2 {
            writeAddr = RegisterDataLocation(register: rp[2]!)
            let address = memoryAccess.readUInt16(workingAddress)
            workingAddress += 2
            readAddr = MemoryDataLocation(address: address, size: .UInt16)
            
          } else if p == 3 {
            writeAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            let address = memoryAccess.readUInt16(workingAddress)
            workingAddress += 2
            readAddr = MemoryDataLocation(address: address, size: .UInt16)
            
          }
        }
        
        parsedInstruction = LD(readLocation: readAddr, writeLocation: writeAddr)
        
      case 3 :
        let reg = rp[Int(p)]!
        if q == 0 { // 16Bit INC
          parsedInstruction = INC(register: reg, size: .UInt16)
          
        } else { // 16Bit DEC
          parsedInstruction = DEC(register: reg, size: .UInt16)
        }
        
      case 4 : // 8Bit INC
        let reg = getDataLocationFor(Int(p))
        parsedInstruction = INC(locToIncrease: reg)
        
      case 5 :
        let reg = getDataLocationFor(Int(p))
        parsedInstruction = DEC(locToIncrease: reg)
        
      case 6 : // LD r[y], n
        let reg = getDataLocationFor(Int(p))
        let val = memoryAccess.readUInt8(workingAddress)
        workingAddress += 1
        let writeAddr = reg
        let readAddr = ConstantDataLocation(value: val)
        
      case 7 :
        
        //MISSING OPCODES
        assertionFailure("unknown value for z in opcode!")
      default :
        assertionFailure("unknown value for z in opcode!")
      }
    case 1 :
      if z == 6 {
        parsedInstruction = HALT()
      }
      else {
        let regRead = getDataLocationFor(Int(z))
        let regWrite = getDataLocationFor(Int(y))
        
        parsedInstruction = LD(readLocation: regRead, writeLocation: regWrite)
        
      }
    case 2 :
      //ALU[y] r[z]
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