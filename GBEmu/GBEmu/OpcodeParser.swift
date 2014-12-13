//
//  OpcodeParser.swift
//  GBEmu
//
//  Created by Maurus Kühne on 24.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class OpcodeParser {
  let registerIndexDict =
  [0 : Register.B,
    1 : Register.C,
    2 : Register.D,
    3 : Register.E,
    4 : Register.H,
    5 : Register.L,
    6 : Register.HL,
    7 : Register.A]
  
  let rp = [0 : Register.BC,
    1 : Register.DE,
    2 : Register.HL,
    3 : Register.SP]
  
  let rp2 = [0 : Register.BC,
    1 : Register.DE,
    2 : Register.HL,
    3 : Register.AF]
  
  let cc = [0 : JumpCondition.NotZero,
    1 : JumpCondition.Zero,
    2 : JumpCondition.NotCarry,
    3 : JumpCondition.Carry]
  
  func getDataLocationFor(idx : Int) -> ReadWriteDataLocation {
    let register = registerIndexDict[idx]!
    
    if register == .HL {
      return RegisterDataLocation(register: register, dereferenceFirst: true)
    } else {
      return RegisterDataLocation(register: register)
    }
  }
  
  func getAluInstructionForIndex(index : Int, withReadLocation: ReadableDataLocation) -> Instruction {
    
    let locationRegA = getDataLocationFor(7)
    
    let sbcInstr = SBC(registerToStore: locationRegA, registerToSubtract: withReadLocation)
    let adcInstr = ADC(registerToStore: locationRegA, registerToAdd: withReadLocation)
    
    let aluInstructions : [Int: Instruction] =
     [0 : ADD(registerToStore: locationRegA, registerToAdd: withReadLocation),
      1 : adcInstr,
      2 : SUB(registerToStore: locationRegA, registerToSubtract: withReadLocation),
      3 : sbcInstr,
      4 : AND(register: withReadLocation),
      5 : XOR(register: withReadLocation), // XOR,
      6 : OR(register: withReadLocation), //Register.HL,
      7 : CP(register: withReadLocation)] //Register.A]
    
    let val = aluInstructions[index]
    
    return val!
  }
  
  func parseInstruction(firstOpcodeByte : UInt8, fetchNextBytePredicate : () -> UInt8) -> Instruction {
    
    func fetchUInt16() -> UInt16 {
      let b1 = fetchNextBytePredicate()
      let b2 = fetchNextBytePredicate()
      return UInt16.fromUpperByte(b2, lowerByte: b1)
    }
    
    var parsedInstruction : Instruction!
    
    let x = (firstOpcodeByte & 0b1100_0000) >> 6
    let y = (firstOpcodeByte & 0b0011_1000) >> 3
    let z = (firstOpcodeByte & 0b0000_0111)
    let p = (firstOpcodeByte & 0b0011_0000) >> 4
    let q = (firstOpcodeByte & 0b0000_1000) >> 3
    let r = (firstOpcodeByte & 0b0010_0000) >> 5
    
    switch(x) {
    case 0 :
      switch(z) {
      case 0 :
        switch(y) {
        case 0 :
          parsedInstruction = NOP()
        case 1 :
          
          let read = RegisterDataLocation(register: Register.SP, dereferenceFirst: false)
          let writeAddr = fetchUInt16()
          let write = MemoryDataLocation(address: writeAddr, size: .UInt16)
          
          parsedInstruction = LD(readLocation: read, writeLocation: write)
        case 2 :
          
          //MISSING OPCODE
          // STOP (nn)
          
          assertionFailure("unknown value for y in opcode!")
        case 3 :
          let offset = sint8(bitPattern: fetchNextBytePredicate())
          parsedInstruction = JP(locationToRead: ConstantDataLocation(value: offset), isRelative: true, condition: nil)
        default :
          
          let condition = cc[Int(y) - 4]!
          
          let val = fetchUInt16()
          let loc = ConstantDataLocation(value: val)
          
          parsedInstruction = JP(locationToRead: loc, isRelative: false, condition: condition)
        }
      case 1 : //x = 0, z = 1
        if q == 0 {
          let reg = rp[Int(p)]!
          let writeAddr = RegisterDataLocation(register: reg)
          
          let valueToLoad = fetchUInt16()
          let constRead = ConstantDataLocation(value: valueToLoad)
          parsedInstruction = LD(readLocation: constRead, writeLocation: writeAddr)
        }
        else {
          
          let writeReg = RegisterDataLocation(register: Register.HL, dereferenceFirst: false)
          let readReg = RegisterDataLocation(register: rp[Int(p)]!, dereferenceFirst: false)
          parsedInstruction = ADD(registerToStore: writeReg, registerToAdd: readReg)
        }
      case 2 : // z = 2
        
        var readAddr : ReadableDataLocation!
        var writeAddr : WriteableDataLocation!
        
        if q == 0 {
          if p == 0 {
            readAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            writeAddr = RegisterDataLocation(register: Register.BC, dereferenceFirst: true)
            
          } else if p == 1 {
            readAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            writeAddr = RegisterDataLocation(register: Register.DE, dereferenceFirst: true)
            
          } else if p == 2 {
            
            let address = fetchUInt16()
            writeAddr = MemoryDataLocation(address: address, size: .UInt16)
            readAddr = RegisterDataLocation(register: Register.HL, dereferenceFirst: true)
            
          } else if p == 3 {
            let address = fetchUInt16()
            
            writeAddr = MemoryDataLocation(address: address, size: .UInt16)
            readAddr = RegisterDataLocation(register: Register.HL, dereferenceFirst: true)
            
          }
        }
        else { //q == 1
          if p == 0 {
            writeAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            readAddr = RegisterDataLocation(register: Register.BC, dereferenceFirst: true)
            
          } else if p == 1 {
            writeAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            readAddr = RegisterDataLocation(register: Register.DE, dereferenceFirst: true)
            
          } else if p == 2 {
            writeAddr = RegisterDataLocation(register: rp[2]!)
            let address = fetchUInt16()
            readAddr = MemoryDataLocation(address: address, size: .UInt16)
            
          } else if p == 3 {
            writeAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            let address = fetchUInt16()
            readAddr = MemoryDataLocation(address: address, size: .UInt16)
            
          }
        }
        
        parsedInstruction = LD(readLocation: readAddr, writeLocation: writeAddr)
        
      case 3 :
        let reg = rp[Int(p)]!
        if q == 0 { // 16Bit INC
          parsedInstruction = INC(register: reg)
          
        } else { // 16Bit DEC
          parsedInstruction = DEC(register: reg)
        }
        
      case 4 : // 8Bit INC
        let reg = getDataLocationFor(Int(p))
        parsedInstruction = INC(locToIncrease: reg)
        
      case 5 :
        let reg = getDataLocationFor(Int(p))
        parsedInstruction = DEC(locToDecrease: reg)
        
      case 6 : // LD r[y], n
        let reg = getDataLocationFor(Int(p))
        let val = fetchNextBytePredicate()
        
        let writeAddr = reg
        let readAddr = ConstantDataLocation(value: val)
        
        parsedInstruction = LD(readLocation: readAddr, writeLocation: writeAddr)
        
      case 7 :
        switch(y) {
        case 0 :
          parsedInstruction = RLCA()
          
        case 1 :
          parsedInstruction = RRCA()
          
        case 2 :
          parsedInstruction = RLA()
          
        case 3 :
          parsedInstruction = RRA()
          
        default :
          assertionFailure("unknown value for y in opcode!")
        }
        
      default :
        assertionFailure("unknown value for z in opcode!")
      }
    case 1 :
      if z == 6 && y == 6 {
        parsedInstruction = HALT()
      }
      else {
        let regRead = getDataLocationFor(Int(z))
        let regWrite = getDataLocationFor(Int(y))
        
        parsedInstruction = LD(readLocation: regRead, writeLocation: regWrite)
        
      }
    case 2 :
      
      let secondRegister = getDataLocationFor(Int(z))
      parsedInstruction = getAluInstructionForIndex(Int(y), withReadLocation: secondRegister)
      
    case 3 : // x = 3
      
      switch(z) {
      case 0 :
        switch(y) {
          
        case 4 :
          let regRead = RegisterDataLocation(register: Register.A)
          let nextByte = fetchNextBytePredicate()
          let location = 0xFF00 + nextByte.getAsUInt16()
          let memLoc = MemoryDataLocation(address: location, size: DataSize.UInt16)
          
          parsedInstruction = LD(readLocation: regRead, writeLocation: memLoc)
        
        case 5 :
          let value = Int8(fetchNextBytePredicate())
          let offset = ConstantDataLocation(value: value)
          let writeLoc = RegisterDataLocation(register: Register.SP, dereferenceFirst: false)
          
          parsedInstruction = ADD(registerToStore: writeLoc, registerToAdd: offset)
          
        case 6 :
          let regRead = RegisterDataLocation(register: Register.A)
          let nextByte = fetchNextBytePredicate()
          let location = 0xFF00 + nextByte.getAsUInt16()
          let readLoc = ConstantDataLocation(value: location)
          
          parsedInstruction = LD(readLocation: readLoc, writeLocation: regRead)
          
        case 7 :
          let writeReg = RegisterDataLocation(register: Register.HL)
          let offset = fetchNextBytePredicate()
          let readReg = RegisterDataLocation(register: Register.SP, offset: Int32(offset))
          parsedInstruction = LD(readLocation: readReg, writeLocation: writeReg)
         
        default :
          let condition = cc[Int(y)]!
          parsedInstruction = RET(condition: condition)
        }
      case 1 :
        if q == 0 {
          let reg = rp2[Int(p)]!
          let loc = RegisterDataLocation(register: reg)
          
          parsedInstruction = POP(locationToStore: loc)
          
        } else {
          switch(p) {
          case 0 :
            parsedInstruction = RET()
          case 1 :
            parsedInstruction = RET(enableInterrupts: true)
          case 2 :
            let val = RegisterDataLocation(register: Register.HL)
            parsedInstruction = JP(locationToRead: val)
          case 3 :
            let writeReg = RegisterDataLocation(register: Register.SP)
            let readReg = RegisterDataLocation(register: Register.HL)
            parsedInstruction = LD(readLocation: readReg, writeLocation: writeReg)
          default :
            assertionFailure("not yet implemented")
          }
        }
      case 2 :
        if r == 1 {
          let readReg = getDataLocationFor(7)
          let writeLoc = RegisterDataLocation(register: Register.C, offset: 0xFF00)
          parsedInstruction = LD(readLocation: readReg, writeLocation: writeLoc)
        } else {
          let condition = cc[Int(y)]!
          let addr = fetchUInt16()
          let loc = ConstantDataLocation(value: addr)
          
          parsedInstruction = JP(locationToRead: loc, isRelative: false, condition: condition)
        }
      case 3 :
        switch(y) {
        case 0 :
          let addr = fetchUInt16()
          let loc = ConstantDataLocation(value: addr)
          parsedInstruction = JP(locationToRead: loc)
        case 6 :
          parsedInstruction = DI()
        case 7 :
          parsedInstruction = EI()
        default :
          assertionFailure("not yet implemented")
        }
      case 4 :
        
        let condition = cc[Int(y)]
        let address = fetchUInt16()
        let loc = ConstantDataLocation(value: address)
        parsedInstruction = CALL(addressToCall: loc, condition: condition)
      case 5 :
        if q == 0 {
          let reg = rp2[Int(p)]!
          let loc = RegisterDataLocation(register: reg)
          
          parsedInstruction = PUSH(locationToWrite: loc)
        } else {
          switch(p) {
          case 0 :
            let address = fetchUInt16()
            let loc = ConstantDataLocation(value: address)
            parsedInstruction = CALL(addressToCall: loc)
          default :
            assertionFailure("not yet implemented")
          }
        }
      case 6 :
        
        let readLocation = ConstantDataLocation(value: fetchNextBytePredicate())
        parsedInstruction = getAluInstructionForIndex(Int(y), withReadLocation: readLocation)
      case 7 :
        let val : UInt8 = y * 8
        
        parsedInstruction = RST(newPCValue: val)
      default :
        assertionFailure("not yet implemented")
      }
      
    default :
      assertionFailure("unknown value for x in opcode!")
    }
    
    if parsedInstruction == nil {
      parsedInstruction = Instruction()
    }
    
    return parsedInstruction
  }
}