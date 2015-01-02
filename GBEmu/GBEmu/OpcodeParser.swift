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
  
  func getRotateInstructionForIndex(index : Int, withRegisterIndex: Int, opcode : UInt8, prefix : UInt8? = nil) -> Instruction {
    
    let location = getDataLocationFor(withRegisterIndex)
    
    switch(index) {
    case 0 :
      return RLC(opcode: opcode, prefix : prefix, register: location)
    case 1 :
      return RRC(opcode: opcode, prefix : prefix, register: location)
    case 2 :
      return RL(opcode: opcode, prefix : prefix, register: location)
    case 3 :
      return RR(opcode: opcode, prefix : prefix, register: location)
    case 4 :
      return SLA(opcode: opcode, prefix : prefix, register: location)
    case 5 :
      return SRA(opcode: opcode, prefix : prefix, register: location)
    case 6 :
      if let x = prefix {
        return SWAP(opcode: opcode, prefix: prefix, register: location)
      } else {
        return SCF(opcode: opcode, prefix : prefix)
      }
      
    case 7 :
      return SRL(opcode: opcode, prefix : prefix, register: location)
    default :
      assertionFailure("invalid index")
    }
  }
  
  func getAluInstructionForIndex(index : Int, withReadLocation: ReadableDataLocation, opcode : UInt8) -> Instruction {
    
    let locationRegA = getDataLocationFor(7)
    
    switch(index) {
    case 0 :
      return ADD(opcode: opcode, registerToStore: locationRegA, registerToAdd: withReadLocation)
    case 1 :
      return ADC(opcode: opcode, registerToStore: locationRegA, registerToAdd: withReadLocation)
    case 2 :
      return SUB(opcode: opcode, registerToStore: locationRegA, registerToSubtract: withReadLocation)
    case 3 :
      return SBC(opcode: opcode, registerToStore: locationRegA, registerToSubtract: withReadLocation)
    case 4 :
      return AND(opcode: opcode, register: withReadLocation)
    case 5 :
      return XOR(opcode: opcode, register: withReadLocation)
    case 6 :
      return OR(opcode: opcode, register: withReadLocation)
    case 7 :
      return CP(opcode: opcode, register: withReadLocation)
    default :
      assertionFailure("invalid index")
    }
  }
  
  func parseInstruction(firstOpcodeByte : UInt8, fetchNextBytePredicate : () -> UInt8) -> Instruction {
    
    let opcode = firstOpcodeByte
    
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
          parsedInstruction = NOP(opcode: opcode)
        case 1 :
          
          let read = RegisterDataLocation(register: Register.SP, dereferenceFirst: false)
          let writeAddr = fetchUInt16()
          let write = MemoryDataLocation(address: writeAddr, size: .UInt16)
          
          parsedInstruction = LD(opcode: opcode, readLocation: read, writeLocation: write)
        case 2 :
          
          //MISSING OPCODE
          // STOP (nn)
          
          assertionFailure("unknown value for y in opcode!")
        case 3 :
          let offset = sint8(bitPattern: fetchNextBytePredicate())
          parsedInstruction = JP(opcode: opcode, locationToRead: ConstantDataLocation(value: offset), isRelative: true, condition: nil)
        default :
          
          let condition = cc[Int(y) - 4]!
          
          let val = sint8(bitPattern: fetchNextBytePredicate())
          let loc = ConstantDataLocation(value: val)
          
          parsedInstruction = JP(opcode: opcode, locationToRead: loc, isRelative: true, condition: condition)
        }
      case 1 : //x = 0, z = 1
        if q == 0 {
          let reg = rp[Int(p)]!
          let writeAddr = RegisterDataLocation(register: reg)
          
          let valueToLoad = fetchUInt16()
          let constRead = ConstantDataLocation(value: valueToLoad)
          parsedInstruction = LD(opcode: opcode, readLocation: constRead, writeLocation: writeAddr)
        }
        else {
          
          let writeReg = RegisterDataLocation(register: Register.HL, dereferenceFirst: false)
          let readReg = RegisterDataLocation(register: rp[Int(p)]!, dereferenceFirst: false)
          parsedInstruction = ADD(opcode: opcode, registerToStore: writeReg, registerToAdd: readReg)
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
            // LD HL+, A
            let read = RegisterDataLocation(register: Register.A)
            let write = RegisterDataLocation(register: Register.HL, dereferenceFirst: true)
            parsedInstruction = LDIncDec(opcode: firstOpcodeByte, prefix: nil, readLocation: read, writeLocation: write, operation: .Inc)
          } else if p == 3 {
            let read = RegisterDataLocation(register: Register.A)
            let write = RegisterDataLocation(register: Register.HL, dereferenceFirst: true)
            parsedInstruction = LDIncDec(opcode: firstOpcodeByte, prefix: nil, readLocation: read, writeLocation: write, operation: .Dec)
          }
        }
        else { //q == 1
          if p == 0 { //0x0a
            writeAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            readAddr = RegisterDataLocation(register: Register.BC, dereferenceFirst: true)
            
          } else if p == 1 { //0x1a
            writeAddr = RegisterDataLocation(register: registerIndexDict[7]!)
            readAddr = RegisterDataLocation(register: Register.DE, dereferenceFirst: true)
            
          } else if p == 2 {
            // LD A,HL+
            let write = RegisterDataLocation(register: Register.A)
            let read = RegisterDataLocation(register: Register.HL, dereferenceFirst: true)
            parsedInstruction = LDIncDec(opcode: firstOpcodeByte, prefix: nil, readLocation: read, writeLocation: write, operation: .Inc)
            
          } else if p == 3 {
            // LD A,HL-
            let write = RegisterDataLocation(register: Register.A)
            let read = RegisterDataLocation(register: Register.HL, dereferenceFirst: true)
            parsedInstruction = LDIncDec(opcode: firstOpcodeByte, prefix: nil, readLocation: read, writeLocation: write, operation: .Dec)
          }
        }
        
        if parsedInstruction == nil {
          parsedInstruction = LD(opcode: opcode, readLocation: readAddr, writeLocation: writeAddr)
        }
        
      case 3 :
        let reg = rp[Int(p)]!
        if q == 0 { // 16Bit INC
          parsedInstruction = INC(opcode: opcode, register: reg)
          
        } else { // 16Bit DEC
          parsedInstruction = DEC(opcode: opcode, register: reg)
        }
        
      case 4 : // 8Bit INC
        let reg = getDataLocationFor(Int(y))
        parsedInstruction = INC(opcode: opcode, locToIncrease: reg)
        
      case 5 :
        let reg = getDataLocationFor(Int(y))
        parsedInstruction = DEC(opcode: opcode, locToDecrease: reg)
        
      case 6 : // LD r[y], n
        let reg = getDataLocationFor(Int(y))
        let val = fetchNextBytePredicate()
        
        let writeAddr = reg
        let readAddr = ConstantDataLocation(value: val)
        
        parsedInstruction = LD(opcode: opcode, readLocation: readAddr, writeLocation: writeAddr)
        
      case 7 :
        switch(y) {
        case 0 :
          parsedInstruction = RLC(opcode: opcode, register: getDataLocationFor(7))
          
        case 1 :
          parsedInstruction = RRC(opcode: opcode, register: getDataLocationFor(7))
          
        case 2 :
          parsedInstruction = RL(opcode: opcode, register: getDataLocationFor(7))
          
        case 3 :
          parsedInstruction = RR(opcode: opcode, register: getDataLocationFor(7))
          
        case 5 :
          parsedInstruction = CPL(opcode: opcode)
          
        default :
          assertionFailure("unknown value for y in opcode!")
        }
        
      default :
        assertionFailure("unknown value for z in opcode!")
      }
    case 1 :
      if z == 6 && y == 6 {
        parsedInstruction = HALT(opcode: opcode)
      }
      else {
        let regRead = getDataLocationFor(Int(z))
        let regWrite = getDataLocationFor(Int(y))
        
        parsedInstruction = LD(opcode: opcode, readLocation: regRead, writeLocation: regWrite)
        
      }
    case 2 :
      
      let secondRegister = getDataLocationFor(Int(z))
      parsedInstruction = getAluInstructionForIndex(Int(y), withReadLocation: secondRegister, opcode: opcode)
      
    case 3 : // x = 3
      
      switch(z) {
      case 0 :
        switch(y) {
          
        case 4 :
          let regRead = RegisterDataLocation(register: Register.A)
          let nextByte = fetchNextBytePredicate()
          let location = 0xFF00 + nextByte.getAsUInt16()
          let memLoc = MemoryDataLocation(address: location, size: DataSize.UInt16)
          
          parsedInstruction = LD(opcode: opcode, readLocation: regRead, writeLocation: memLoc)
        
        case 5 :
          let value = Int8(fetchNextBytePredicate())
          let offset = ConstantDataLocation(value: value)
          let writeLoc = RegisterDataLocation(register: Register.SP, dereferenceFirst: false)
          
          parsedInstruction = ADD(opcode: opcode, registerToStore: writeLoc, registerToAdd: offset)
          
        case 6 :
          let reg = RegisterDataLocation(register: Register.A)
          let nextByte = fetchNextBytePredicate()
          let location = 0xFF00 + nextByte.getAsUInt16()
          //let readLoc = MemoryDataLocation(address: location, size: .UInt8)
          let readLoc = MemoryDataLocation(address: location, size: .UInt8)
          parsedInstruction = LD(opcode: opcode, readLocation: readLoc, writeLocation: reg)
          
        case 7 :
          let writeReg = RegisterDataLocation(register: Register.HL)
          let offset = fetchNextBytePredicate()
          let readReg = RegisterDataLocation(register: Register.SP, offset: Int32(offset))
          parsedInstruction = LD(opcode: opcode, readLocation: readReg, writeLocation: writeReg)
         
        default :
          let condition = cc[Int(y)]!
          parsedInstruction = RET(opcode: opcode, condition: condition)
        }
      case 1 :
        if q == 0 {
          let reg = rp2[Int(p)]!
          let loc = RegisterDataLocation(register: reg)
          
          parsedInstruction = POP(opcode: opcode, locationToStore: loc)
          
        } else {
          switch(p) {
          case 0 :
            parsedInstruction = RET(opcode: opcode)
          case 1 :
            parsedInstruction = RET(opcode: opcode, enableInterrupts: true)
          case 2 :
            let val = RegisterDataLocation(register: Register.HL)
            parsedInstruction = JP(opcode: opcode, locationToRead: val)
          case 3 :
            let writeReg = RegisterDataLocation(register: Register.SP)
            let readReg = RegisterDataLocation(register: Register.HL)
            parsedInstruction = LD(opcode: opcode, readLocation: readReg, writeLocation: writeReg)
          default :
            assertionFailure("not yet implemented")
          }
        }
      case 2 :
        if r == 1 { // currently handles E2 and EA!!
          let readReg = getDataLocationFor(7)
          var writeLoc : WriteableDataLocation
          if q == 0 {
            writeLoc = RegisterDataLocation(register: Register.C, offset: 0xFF00, dereferenceFirst: true)
          } else {
            let addr = fetchUInt16()
            writeLoc = MemoryDataLocation(address: addr, size: .UInt8)
          }
          
          parsedInstruction = LD(opcode: opcode, readLocation: readReg, writeLocation: writeLoc)
        } else {
          let condition = cc[Int(y)]!
          let addr = fetchUInt16()
          let loc = ConstantDataLocation(value: addr)
          
          parsedInstruction = JP(opcode: opcode, locationToRead: loc, isRelative: false, condition: condition)
        }
      case 3 :
        switch(y) {
        case 0 :
          let addr = fetchUInt16()
          let loc = ConstantDataLocation(value: addr)
          parsedInstruction = JP(opcode: opcode, locationToRead: loc)
        case 6 :
          parsedInstruction = DI(opcode: opcode)
        case 7 :
          parsedInstruction = EI(opcode: opcode)
        default :
          parsedInstruction = getPrefixedOpcode(fetchNextBytePredicate())
        }
      case 4 :
        
        let condition = cc[Int(y)]
        let address = fetchUInt16()
        let loc = ConstantDataLocation(value: address)
        parsedInstruction = CALL(opcode: opcode, addressToCall: loc, condition: condition)
      case 5 :
        if q == 0 {
          let reg = rp2[Int(p)]!
          let loc = RegisterDataLocation(register: reg)
          
          parsedInstruction = PUSH(opcode: opcode, locationToWrite: loc)
        } else {
          switch(p) {
          case 0 :
            let address = fetchUInt16()
            let loc = ConstantDataLocation(value: address)
            parsedInstruction = CALL(opcode: opcode, addressToCall: loc)
          default :
            assertionFailure("not yet implemented")
          }
        }
      case 6 :
        
        let readLocation = ConstantDataLocation(value: fetchNextBytePredicate())
        parsedInstruction = getAluInstructionForIndex(Int(y), withReadLocation: readLocation, opcode: opcode)
      case 7 :
        let val : UInt8 = y * 8
        
        parsedInstruction = RST(opcode: opcode, newPCValue: val)
      default :
        assertionFailure("not yet implemented")
      }
      
    default :
      assertionFailure("unknown value for x in opcode!")
    }
    
    if parsedInstruction == nil {
      parsedInstruction = Instruction(opcode: opcode)
    }
    
    return parsedInstruction
  }
  
  func getPrefixedOpcode(secondOpcodeByte : UInt8) -> Instruction {
    var parsedInstruction : Instruction!
    
    let x = (secondOpcodeByte & 0b1100_0000) >> 6
    let y = (secondOpcodeByte & 0b0011_1000) >> 3
    let z = (secondOpcodeByte & 0b0000_0111)
    let p = (secondOpcodeByte & 0b0011_0000) >> 4
    let q = (secondOpcodeByte & 0b0000_1000) >> 3
    let r = (secondOpcodeByte & 0b0010_0000) >> 5
    
    switch(x) {
    case 0 :
      parsedInstruction = getRotateInstructionForIndex(Int(y), withRegisterIndex: Int(z), opcode: secondOpcodeByte, prefix: 0xCB)
      
    case 1 :
      let reg = getDataLocationFor(Int(z))
      parsedInstruction = BIT(opcode: secondOpcodeByte, prefix: 0xCB, register: reg, bitPosition: y)
      
    case 2 :
      let reg = getDataLocationFor(Int(z))
      parsedInstruction = RES(opcode: secondOpcodeByte, prefix: 0xCB, register: reg, bitPosition: y)
      
    case 3 :
      let reg = getDataLocationFor(Int(z))
      parsedInstruction = SET(opcode: secondOpcodeByte, prefix: 0xCB, register: reg, bitPosition: y)
      
    default :
      assertionFailure("not a valid CB opcode")
    }
    
    if parsedInstruction == nil {
      parsedInstruction = Instruction(opcode: secondOpcodeByte)
    }
    
    return parsedInstruction
  }
}