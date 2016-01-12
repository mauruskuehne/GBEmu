//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class ADC : Instruction {
  let registerToStore : ReadWriteDataLocation
  let registerToAdd : ReadableDataLocation
  
  override var description : String {
    get {
      return "ADC \(registerToStore), \(registerToAdd)"
    }
  }
  
  convenience init(opcode : UInt8, prefix : UInt8? = nil, registerToAdd : RegisterDataLocation) {
    
    let bigRegisters = [ Register.BC, Register.DE, Register.HL, Register.SP ]
    
    var store : RegisterDataLocation
    if bigRegisters.contains(registerToAdd.register) {
      store = RegisterDataLocation(register: Register.HL, dereferenceFirst: false)
    } else {
      store = RegisterDataLocation(register: Register.A, dereferenceFirst: false)
    }
    
    self.init(opcode: opcode, prefix: prefix, registerToStore: store, registerToAdd: registerToAdd)
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, registerToStore : ReadWriteDataLocation, registerToAdd : ReadableDataLocation) {
    self.registerToStore = registerToStore
    self.registerToAdd = registerToAdd
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) -> InstructionResult {

    let oldValue = registerToStore.read(context)
    let valToAdd = registerToAdd.read(context)
    
    let is8BitArithmetic = oldValue is UInt8
    
    let oldValueTyped = oldValue.getAsUInt16()
    let valToAddTyped = valToAdd.getAsUInt16()
    let carryValue : UInt16 = context.registers.Flags.isFlagSet(Flags.Carry) ? 1 : 0
    
    //Execute ADD
    let newValue = oldValueTyped &+ valToAddTyped &+ carryValue
    registerToStore.write(newValue, context: context)
    
    
    //Calculate Flags
    
    let carryThreshold = UInt32(is8BitArithmetic ? UInt16(UInt8.max) : UInt16.max)
    let halfCarryMask = is8BitArithmetic ? UInt16(0x000F) : UInt16(0x0FFF)
    let halfCarryPosition : UInt16 = is8BitArithmetic ? 0x10 : 0x1000
    
    // Carry Flag
    if (UInt32(oldValueTyped) + UInt32(valToAddTyped) + UInt32(carryValue)) > carryThreshold {
      context.registers.Flags.setFlag(Flags.Carry)
    } else {
      context.registers.Flags.resetFlag(Flags.Carry)
    }
    
    //HalfCarry
    let isHalfCarrySet = (oldValueTyped & halfCarryMask) + (valToAddTyped & halfCarryMask) + (carryValue & halfCarryMask) >= halfCarryPosition
    if isHalfCarrySet {
      context.registers.Flags.setFlag(Flags.HalfCarry)
    } else {
      context.registers.Flags.resetFlag(Flags.HalfCarry)
    }
    
    //Zero
    if newValue == 0 {
      context.registers.Flags.setFlag(Flags.Zero)
    } else {
      context.registers.Flags.resetFlag(Flags.Zero)
    }
    
    context.registers.Flags.resetFlag(Flags.Subtract)
    
    return InstructionResult(opcode: self.opcode)
  }
}