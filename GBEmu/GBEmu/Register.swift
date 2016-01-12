//
//  Register.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation


enum Register : Int, CustomStringConvertible {
  case A = 0,
  B = 1,
  C = 2,
  D = 3,
  E = 4,
  H = 5,
  L = 6,
  Flags = 7,
  SP = 8,
  PC = 9,
  AF = 10,
  BC = 11,
  DE = 12,
  HL = 13
  
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