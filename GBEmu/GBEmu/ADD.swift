//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class ADD : Instruction {
  
  let registerToStore : ReadWriteDataLocation
  let registerToAdd : ReadableDataLocation
  
  override var description : String {
    get {
      return "ADD \(registerToStore), \(registerToAdd)"
    }
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
    let carryThreshold = UInt32(is8BitArithmetic ? UInt16(UInt8.max) : UInt16.max)
    let halfCarryMask = is8BitArithmetic ? UInt16(0x000F) : UInt16(0x0FFF)
    let halfCarryPosition : UInt16 = is8BitArithmetic ? 0x10 : 0x1000
    
    if !valToAdd.isSigned {
      let res = ADD.calculateResultForUnsignedAdd(context, oldValue: oldValue, valToAdd: valToAdd)
      registerToStore.write(res.result, context: context)
      
      context.registers.Flags = res.flags
    }
    else {
      //Signed ADD only exists for SP ADD, so we can safely assume the types of the values
      let oldValueTyped = Int32(oldValue.getAsUInt16())
      let valToAddTyped = Int32(valToAdd.getAsSInt8())
      
      if (oldValueTyped + valToAddTyped) > Int32(carryThreshold) {
        context.registers.Flags.setFlag(Flags.Carry)
      } else {
        context.registers.Flags.resetFlag(Flags.Carry)
      }
      
      let oldValueMasked = oldValueTyped & Int32(halfCarryMask)
      let valToAddMasked = valToAddTyped & Int32(halfCarryMask)
      
      let isHalfCarrySet = (oldValueMasked + valToAddMasked) >= Int32(halfCarryPosition)
      if isHalfCarrySet {
        context.registers.Flags.setFlag(Flags.HalfCarry)
      } else {
        context.registers.Flags.resetFlag(Flags.HalfCarry)
      }
      
      
      //Execute ADD
      let newValue = UInt16( Int32(oldValueTyped) &+ Int32(valToAddTyped))
      registerToStore.write(newValue, context: context)
      
    }
    
    context.registers.Flags.resetFlag(Flags.Subtract)
    
    return InstructionResult(opcode: self.opcode)
  }

  class func calculateResultForUnsignedAdd(context : ExecutionContext, oldValue : DataLocationSupported, valToAdd : DataLocationSupported) -> (result : DataLocationSupported, flags : UInt8) {
    
    var flags = context.registers.Flags
    
    let is8BitArithmetic = oldValue is UInt8
    let carryThreshold = UInt32(is8BitArithmetic ? UInt16(UInt8.max) : UInt16.max)
    let halfCarryMask = is8BitArithmetic ? UInt16(0x000F) : UInt16(0x0FFF)
    let halfCarryPosition : UInt16 = is8BitArithmetic ? 0x10 : 0x1000

    let oldValueTyped = oldValue.getAsUInt16()
    let valToAddTyped = valToAdd.getAsUInt16()
    
    //Execute ADD
    let newValue = oldValueTyped &+ valToAddTyped
    
    //Calculate Flags
    
    // Carry Flag
    if (UInt32(oldValueTyped) + UInt32(valToAddTyped)) > carryThreshold {
      flags.setFlag(Flags.Carry)
    } else {
      flags.resetFlag(Flags.Carry)
    }
    
    //HalfCarry
    let isHalfCarrySet = (oldValueTyped & halfCarryMask) + (valToAddTyped & halfCarryMask) >= halfCarryPosition
    if isHalfCarrySet {
      flags.setFlag(Flags.HalfCarry)
    } else {
      flags.resetFlag(Flags.HalfCarry)
    }
    
    //Zero
    if newValue == 0 && is8BitArithmetic {
      flags.setFlag(Flags.Zero)
    } else if is8BitArithmetic {
      flags.resetFlag(Flags.Zero)
    }
    
    flags.resetFlag(Flags.Subtract)
    
    return (newValue, flags)

  }
}