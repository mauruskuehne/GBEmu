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
  var B : UInt8
  var C : UInt8
  var D : UInt8
  var E : UInt8
  var H : UInt8
  var L : UInt8
  var Flags : UInt8
  
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
    SP = 0xFFFF
    PC = 0x100
  }
  
  func reset() {
    A = 0
    B = 0
    C = 0
    D = 0
    E = 0
    H = 0
    L = 0
    Flags = 0
    SP = 0xFFFF
    PC = 0x100
  }
  
  subscript(register : Register) -> UInt8 {
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
      }
    }
    set(newValue) {
      switch(register) {
      case .A:
        self.A = newValue
      case .B:
        self.B = newValue
      case .C:
        self.C = newValue
      case .D:
        self.D = newValue
      case .E:
        self.E = newValue
      case .H:
        self.H = newValue
      case .L:
        self.L = newValue
      case .Flags:
        self.Flags = newValue
      }
    }
  }
  
  subscript(register : DoubleRegister) -> UInt16 {
    get {
      switch(register) {
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
      case .SP:
        self.SP = newValue
      case .PC:
        self.PC = newValue
      case .AF:
        self.AF = newValue
      case .BC:
        self.BC = newValue
      case .DE:
        self.DE = newValue
      case .HL:
        self.HL = newValue
      }
    }
  }
}