//
//  Registers.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation


public class Registers {
  var A : UInt8
  var B : Byte
  var C : Byte
  var D : Byte
  var E : Byte
  var H : Byte
  var L : Byte
  var Flags : Byte
  
  var SP : UInt16
  var PC : UInt16
  
  var AF : UInt16 {
    get {
      return UInt16.fromUpperByte(A, lowerByte: Flags)
    }
    set {
      let bytes = newValue.toBytes()
      A = bytes.upper
      Flags = bytes.lower
    }
  }
  
  var BC : UInt16 {
    get {
      return UInt16.fromUpperByte(B, lowerByte: C)
    }
    set {
      let bytes = newValue.toBytes()
      B = bytes.upper
      C = bytes.lower
    }
  }
  
  var DE : UInt16 {
    get {
      return UInt16.fromUpperByte(D, lowerByte: E)
    }
    set {
      let bytes = newValue.toBytes()
      D = bytes.upper
      E = bytes.lower
    }
  }
  
  var HL : UInt16 {
    get {
      return UInt16.fromUpperByte(H, lowerByte: L)
    }
    set {
      let bytes = newValue.toBytes()
      H = bytes.upper
      L = bytes.lower
    }
  }
  
  init() {
    A = 0
    B = 0
    C = 0
    D = 0
    E = 0
    H = 0
    L = 0
    Flags = 0
    SP = 0
    PC = 0x100
  }
  
  subscript(register : Register) -> DataLocationSupported {
    get {
      switch(register) {
      case .A:
        return self.A
      case .B:
        return self.B
      case .C:
        return self.C
      case .D:
        return self.D
      case .E:
        return self.E
      case .H:
        return self.H
      case .L:
        return self.L
      case .Flags:
        return self.Flags
      case .SP:
        return self.SP
      case .PC:
        return self.PC
      case .AF:
        return self.AF
      case .BC:
        return self.BC
      case .DE:
        return self.DE
      case .HL:
        return self.HL
      }
    }
    set(newValue) {
      switch(register) {
      case .A:
        self.A = newValue.getAsUInt8()
      case .B:
        self.B = newValue.getAsUInt8()
      case .C:
        self.C = newValue.getAsUInt8()
      case .D:
        self.D = newValue.getAsUInt8()
      case .E:
        self.E = newValue.getAsUInt8()
      case .H:
        self.H = newValue.getAsUInt8()
      case .L:
        self.L = newValue.getAsUInt8()
      case .Flags:
        self.Flags = newValue.getAsUInt8()
      case .SP:
        self.SP = newValue.getAsUInt16()
      case .PC:
        self.PC = newValue.getAsUInt16()
      case .AF:
        self.AF = newValue.getAsUInt16()
      case .BC:
        self.BC = newValue.getAsUInt16()
      case .DE:
        self.DE = newValue.getAsUInt16()
      case .HL:
        self.HL = newValue.getAsUInt16()
      }
    }
  }
}