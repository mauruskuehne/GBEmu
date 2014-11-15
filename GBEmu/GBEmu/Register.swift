//
//  Register.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation


enum Register : Printable {
  case A,
  B,
  C,
  D,
  E,
  H,
  L,
  Flags,
  SP,
  PC,
  AF,
  BC,
  DE,
  HL
  
  var description: String {
    get {
      switch(self) {
      case .A:
        return "A"
      case .B:
        return "B"
      case .C:
        return "C"
      case .D:
        return "D"
      case .E:
        return "E"
      case .H:
        return "H"
      case .L:
        return "L"
      case .Flags:
        return "F"
      case .SP:
        return "SP"
      case .PC:
        return "PC"
      case .AF:
        return "AF"
      case .BC:
        return "BC"
      case .DE:
        return "DE"
      case .HL:
        return "HL"
      }
    }
  }
  
}