//
//  Registers.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class Registers {
  var A : Byte
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
    PC = 0
  }
  
}