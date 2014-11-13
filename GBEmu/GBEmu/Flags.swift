//
//  Flags.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

enum Flags : Byte {
  case Zero =       0b10000000
  case Subtract =   0b01000000
  case HalfCarry =  0b00100000
  case Carry =      0b00010000
}