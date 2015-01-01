//
//  InterruptFlag.swift
//  GBEmu
//
//  Created by Maurus Kühne on 01.01.15.
//  Copyright (c) 2015 Maurus Kühne. All rights reserved.
//

import Foundation

enum InterruptFlag : UInt8 {
  case PIN_Hi_Lo_Change =         0b0001_0000
  case Serial_Transfer_Complete = 0b0000_1000
  case Timer_Overflow =           0b0000_0100
  case LCDC =                     0b0000_0010
  case VBlank =                   0b0000_0001
}