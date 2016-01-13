//
//  OpcodeParser.swift
//  GBEmu
//
//  Created by Maurus Kühne on 24.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class OpcodeParserLegacy {
  let registerDataLocations =
   [0 :  RegisterDataLocation(register: Register.B),
    1 : RegisterDataLocation(register: Register.C),
    2 : RegisterDataLocation(register: Register.D),
    3 : RegisterDataLocation(register: Register.E),
    4 : RegisterDataLocation(register: Register.H),
    5 : RegisterDataLocation(register: Register.L),
    6 : RegisterDataLocation(register: Register.HL, dereferenceFirst: true),
    7 : RegisterDataLocation(register: Register.A)]
  
  let dereferenced16BitRegisters =
   [0 : RegisterDataLocation(register: Register.BC, dereferenceFirst: true),
    1 : RegisterDataLocation(register: Register.DE, dereferenceFirst: true),
    2 : RegisterDataLocation(register: Register.HL, dereferenceFirst: true),
    3 : RegisterDataLocation(register: Register.SP, dereferenceFirst: true)]
  
  let rp =
   [0 : RegisterDataLocation(register: Register.BC),
    1 : RegisterDataLocation(register: Register.DE),
    2 : RegisterDataLocation(register: Register.HL),
    3 : RegisterDataLocation(register: Register.SP)]
  
  let rp2 =
   [0 : RegisterDataLocation(register: Register.BC),
    1 : RegisterDataLocation(register: Register.DE),
    2 : RegisterDataLocation(register: Register.HL),
    3 : RegisterDataLocation(register: Register.AF)]
  
  let cc = [0 : JumpCondition.NotZero,
    1 : JumpCondition.Zero,
    2 : JumpCondition.NotCarry,
    3 : JumpCondition.Carry]
  
  func getRotateInstructionForIndex(index : Int, withRegisterIndex: Int, opcode : UInt8, prefix : UInt8? = nil) -> Instruction {
    
    let location = registerDataLocations[withRegisterIndex]!
    
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
        return SWAP(opcode: opcode, prefix: x, register: location)
      } else {
        return SCF(opcode: opcode, prefix : prefix)
      }
      
    case 7 :
      return SRL(opcode: opcode, prefix : prefix, register: location)
    default :
      fatalError("invalid index")
    }
  }
  
  func getAluInstructionForIndex(index : Int, withReadLocation: ReadableDataLocation, opcode : UInt8) -> Instruction {
    
    let locationRegA = registerDataLocations[7]!
    
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
      fatalError("invalid index")
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
          
          let read = rp[3]!
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
          let writeAddr = rp[Int(p)]!
          
          let valueToLoad = fetchUInt16()
          let constRead = ConstantDataLocation(value: valueToLoad)
          parsedInstruction = LD(opcode: opcode, readLocation: constRead, writeLocation: writeAddr)
        }
        else {
          
          let writeReg = rp[2]!
          let readReg = rp[Int(p)]!
          parsedInstruction = ADD(opcode: opcode, registerToStore: writeReg, registerToAdd: readReg)
        }
      case 2 : // z = 2
        
        var readAddr : ReadableDataLocation!
        var writeAddr : WriteableDataLocation!
        
        if q == 0 {
          if p == 0 {
            readAddr = registerDataLocations[7]!
            writeAddr = dereferenced16BitRegisters[0]!
            
          } else if p == 1 {
            readAddr = registerDataLocations[7]!
            writeAddr = dereferenced16BitRegisters[1]!
            
          } else if p == 2 {
            // LD HL+, A
            let read = registerDataLocations[7]!
            let write = dereferenced16BitRegisters[2]!
            parsedInstruction = LDIncDec(opcode: firstOpcodeByte, prefix: nil, readLocation: read, writeLocation: write, operation: .Inc)
          } else if p == 3 {
            let read = registerDataLocations[7]!
            let write = dereferenced16BitRegisters[2]!
            parsedInstruction = LDIncDec(opcode: firstOpcodeByte, prefix: nil, readLocation: read, writeLocation: write, operation: .Dec)
          }
        }
        else { //q == 1
          if p == 0 { //0x0a
            writeAddr = registerDataLocations[7]!
            readAddr = dereferenced16BitRegisters[0]!
            
          } else if p == 1 { //0x1a
            writeAddr = registerDataLocations[7]!
            readAddr = dereferenced16BitRegisters[1]!
            
          } else if p == 2 {
            // LD A,HL+
            let write = registerDataLocations[7]!
            let read = dereferenced16BitRegisters[2]!
            parsedInstruction = LDIncDec(opcode: firstOpcodeByte, prefix: nil, readLocation: read, writeLocation: write, operation: .Inc)
            
          } else if p == 3 {
            // LD A,HL-
            let write = registerDataLocations[7]!
            let read = dereferenced16BitRegisters[2]!
            parsedInstruction = LDIncDec(opcode: firstOpcodeByte, prefix: nil, readLocation: read, writeLocation: write, operation: .Dec)
          }
        }
        
        if parsedInstruction == nil {
          parsedInstruction = LD(opcode: opcode, readLocation: readAddr, writeLocation: writeAddr)
        }
        
      case 3 :
        let reg = rp[Int(p)]!
        if q == 0 { // 16Bit INC
          parsedInstruction = INC(opcode: opcode, locToIncrease: reg)
          
        } else { // 16Bit DEC
          parsedInstruction = DEC(opcode: opcode, locToDecrease: reg)
        }
        
      case 4 : // 8Bit INC
        let reg = registerDataLocations[Int(y)]!
        parsedInstruction = INC(opcode: opcode, locToIncrease: reg)
        
      case 5 :
        let reg = registerDataLocations[Int(y)]!
        parsedInstruction = DEC(opcode: opcode, locToDecrease: reg)
        
      case 6 : // LD r[y], n
        let reg = registerDataLocations[Int(y)]!
        let val = fetchNextBytePredicate()
        
        let writeAddr = reg
        let readAddr = ConstantDataLocation(value: val)
        
        parsedInstruction = LD(opcode: opcode, readLocation: readAddr, writeLocation: writeAddr)
        
      case 7 :
        switch(y) {
        case 0 :
          parsedInstruction = RLC(opcode: opcode, register: registerDataLocations[7]!)
          
        case 1 :
          parsedInstruction = RRC(opcode: opcode, register: registerDataLocations[7]!)
          
        case 2 :
          parsedInstruction = RL(opcode: opcode, register: registerDataLocations[7]!)
          
        case 3 :
          parsedInstruction = RR(opcode: opcode, register: registerDataLocations[7]!)
          
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
        let regRead = registerDataLocations[Int(z)]!
        let regWrite = registerDataLocations[Int(y)]!
        
        parsedInstruction = LD(opcode: opcode, readLocation: regRead, writeLocation: regWrite)
        
      }
    case 2 :
      
      let secondRegister = registerDataLocations[Int(z)]!
      parsedInstruction = getAluInstructionForIndex(Int(y), withReadLocation: secondRegister, opcode: opcode)
      
    case 3 : // x = 3
      
      switch(z) {
      case 0 :
        switch(y) {
          
        case 4 :
          let regRead = registerDataLocations[7]!
          let nextByte = fetchNextBytePredicate()
          let location = 0xFF00 + nextByte.getAsUInt16()
          let memLoc = MemoryDataLocation(address: location, size: DataSize.UInt16)
          
          parsedInstruction = LD(opcode: opcode, readLocation: regRead, writeLocation: memLoc)
        
        case 5 :
          let value = Int8(fetchNextBytePredicate())
          let offset = ConstantDataLocation(value: value)
          let writeLoc = rp[3]!
          
          parsedInstruction = ADD(opcode: opcode, registerToStore: writeLoc, registerToAdd: offset)
          
        case 6 :
          let reg = registerDataLocations[7]!
          let nextByte = fetchNextBytePredicate()
          let location = 0xFF00 + nextByte.getAsUInt16()
          //let readLoc = MemoryDataLocation(address: location, size: .UInt8)
          let readLoc = MemoryDataLocation(address: location, size: .UInt8)
          parsedInstruction = LD(opcode: opcode, readLocation: readLoc, writeLocation: reg)
          
        case 7 :
          let writeReg = rp[2]!
          let offset = fetchNextBytePredicate()
          let readReg = RegisterDataLocation(register: Register.SP, offset: Int32(offset))
          parsedInstruction = LD(opcode: opcode, readLocation: readReg, writeLocation: writeReg)
         
        default :
          let condition = cc[Int(y)]!
          parsedInstruction = RET(opcode: opcode, condition: condition)
        }
      case 1 :
        if q == 0 {
          let loc = rp2[Int(p)]!
          
          parsedInstruction = POP(opcode: opcode, locationToStore: loc)
          
        } else {
          switch(p) {
          case 0 :
            parsedInstruction = RET(opcode: opcode)
          case 1 :
            parsedInstruction = RET(opcode: opcode, enableInterrupts: true)
          case 2 :
            let val = rp[2]!
            parsedInstruction = JP(opcode: opcode, locationToRead: val)
          case 3 :
            let writeReg = rp[3]!
            let readReg = rp[2]!
            parsedInstruction = LD(opcode: opcode, readLocation: readReg, writeLocation: writeReg)
          default :
            assertionFailure("not yet implemented")
          }
        }
      case 2 :
        if r == 1 {
          let readReg = registerDataLocations[7]!
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
          let loc = rp2[Int(p)]!
          
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
    
    switch(x) {
    case 0 :
      parsedInstruction = getRotateInstructionForIndex(Int(y), withRegisterIndex: Int(z), opcode: secondOpcodeByte, prefix: 0xCB)
      
    case 1 :
      let reg = registerDataLocations[Int(z)]!
      parsedInstruction = BIT(opcode: secondOpcodeByte, prefix: 0xCB, register: reg, bitPosition: y)
      
    case 2 :
      let reg = registerDataLocations[Int(z)]!
      parsedInstruction = RES(opcode: secondOpcodeByte, prefix: 0xCB, register: reg, bitPosition: y)
      
    case 3 :
      let reg = registerDataLocations[Int(z)]!
      parsedInstruction = SET(opcode: secondOpcodeByte, prefix: 0xCB, register: reg, bitPosition: y)
      
    default :
      fatalError("not a valid CB opcode")
    }
    
    if parsedInstruction == nil {
      parsedInstruction = Instruction(opcode: secondOpcodeByte)
    }
    
    return parsedInstruction
  }
}