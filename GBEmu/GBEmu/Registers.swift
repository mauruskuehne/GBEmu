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
      
    }
  }
}