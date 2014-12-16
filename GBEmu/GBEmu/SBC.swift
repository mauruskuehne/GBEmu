//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SBC : Instruction {
  
  let registerToStore : ReadWriteDataLocation
  let registerToSubtract : ReadableDataLocation
  
  override var description : String {
    get {
      return "SBC \(registerToStore), \(registerToSubtract)"
    }
  }
  
  convenience init(opcode : UInt8, prefix : UInt8? = nil, registerToSubtract : RegisterDataLocation) {
    
    let bigRegisters = [ Register.BC, Register.DE, Register.HL, Register.SP ]
    
    var store : RegisterDataLocation
    if contains(bigRegisters, registerToSubtract.register) {
      store = RegisterDataLocation(register: Register.HL, dereferenceFirst: false)
    } else {
      store = RegisterDataLocation(register: Register.A, dereferenceFirst: false)
    }
    
    self.init(opcode: opcode, prefix: prefix, registerToStore: store, registerToSubtract: registerToSubtract)
  }
  
  init(opcode : UInt8, prefix : UInt8? = nil, registerToStore : ReadWriteDataLocation, registerToSubtract : ReadableDataLocation) {
    self.registerToStore = registerToStore
    self.registerToSubtract = registerToSubtract
    
    super.init(opcode: opcode, prefix: prefix)
  }
  
  override func execute(context : ExecutionContext) {
    
    let oldValue = registerToStore.read(context)
    let valToSub = registerToSubtract.read(context)
    
    let is8BitArithmetic = oldValue is UInt8
    
    let oldValueTyped = oldValue.getAsUInt16()
    let valToSubTyped = valToSub.getAsUInt16()
    let carryValue : UInt16 = context.registers.Flags.isFlagSet(Flags.Carry) ? 1 : 0
    
    //Execute SUB
    let newValue = oldValueTyped &- valToSubTyped &- carryValue
    registerToStore.write(newValue, context: context)
    
    //Calculate Flags
    
    // Subtract Flag
    context.registers.Flags.setFlag(Flags.Subtract)
    
    // Zero Flag
    if newValue == 0 {
      context.registers.Flags.setFlag(Flags.Zero)
    } else {
      context.registers.Flags.resetFlag(Flags.Zero)
    }
    
    //Carry Flag
    if UInt32(oldValueTyped) < (UInt32(valToSubTyped) + UInt32(carryValue)) {
      context.registers.Flags.setFlag(Flags.Carry)
    } else {
      context.registers.Flags.resetFlag(Flags.Carry)
    }
    
    //HalfCarry Flag
    let halfCarryPosition : UInt16 = is8BitArithmetic ? 0x10 : 0x1000
    let halfCarryMask : UInt16 = is8BitArithmetic ? 0x0F : 0x0FFF
    
    if (oldValueTyped & halfCarryMask) < ((valToSubTyped & halfCarryMask) + (carryValue & halfCarryMask)){
      context.registers.Flags.setFlag(Flags.HalfCarry)
    } else {
      context.registers.Flags.resetFlag(Flags.HalfCarry)
    }
    
  }
}