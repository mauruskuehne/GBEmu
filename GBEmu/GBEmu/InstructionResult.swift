//
//  InstructionResult.swift
//  GBEmu
//
//  Created by Maurus Kühne on 16/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

struct OpcodeTimesContainer {
  
  static let opcodeTimes = [
    0x00 : OpcodeTime(executed: 4),
    0x01 : OpcodeTime(executed: 12),
    0x02 : OpcodeTime(executed: 8),
    0x03 : OpcodeTime(executed: 8),
    0x04 : OpcodeTime(executed: 4),
    0x05 : OpcodeTime(executed: 4),
    0x06 : OpcodeTime(executed: 8),
    0x07 : OpcodeTime(executed: 4),
    0x08 : OpcodeTime(executed: 20),
    0x09 : OpcodeTime(executed: 8),
    0x0A : OpcodeTime(executed: 8),
    0x0B : OpcodeTime(executed: 8),
    0x0C : OpcodeTime(executed: 4),
    0x0D : OpcodeTime(executed: 4),
    0x0E : OpcodeTime(executed: 8),
    0x0F : OpcodeTime(executed: 4),
    
    0x10 : OpcodeTime(executed: 4),
    0x11 : OpcodeTime(executed: 12),
    0x12 : OpcodeTime(executed: 8),
    0x13 : OpcodeTime(executed: 8),
    0x14 : OpcodeTime(executed: 4),
    0x15 : OpcodeTime(executed: 4),
    0x16 : OpcodeTime(executed: 8),
    0x17 : OpcodeTime(executed: 4),
    0x18 : OpcodeTime(executed: 12),
    0x19 : OpcodeTime(executed: 8),
    0x1A : OpcodeTime(executed: 8),
    0x1B : OpcodeTime(executed: 8),
    0x1C : OpcodeTime(executed: 4),
    0x1D : OpcodeTime(executed: 4),
    0x1E : OpcodeTime(executed: 8),
    0x1F : OpcodeTime(executed: 4),
    
    0x20 : OpcodeTime(executed: 12, notExecuted: 8),
    0x21 : OpcodeTime(executed: 12),
    0x22 : OpcodeTime(executed: 8),
    0x23 : OpcodeTime(executed: 8),
    0x24 : OpcodeTime(executed: 4),
    0x25 : OpcodeTime(executed: 4),
    0x26 : OpcodeTime(executed: 8),
    0x27 : OpcodeTime(executed: 4),
    0x28 : OpcodeTime(executed: 12, notExecuted: 8),
    0x29 : OpcodeTime(executed: 8),
    0x2A : OpcodeTime(executed: 8),
    0x2B : OpcodeTime(executed: 8),
    0x2C : OpcodeTime(executed: 4),
    0x2D : OpcodeTime(executed: 4),
    0x2E : OpcodeTime(executed: 8),
    0x2F : OpcodeTime(executed: 4),
    
    0x30 : OpcodeTime(executed: 12, notExecuted: 8),
    0x31 : OpcodeTime(executed: 12),
    0x32 : OpcodeTime(executed: 8),
    0x33 : OpcodeTime(executed: 8),
    0x34 : OpcodeTime(executed: 12),
    0x35 : OpcodeTime(executed: 12),
    0x36 : OpcodeTime(executed: 12),
    0x37 : OpcodeTime(executed: 4),
    0x38 : OpcodeTime(executed: 12, notExecuted: 8),
    0x39 : OpcodeTime(executed: 8),
    0x3A : OpcodeTime(executed: 8),
    0x3B : OpcodeTime(executed: 8),
    0x3C : OpcodeTime(executed: 4),
    0x3D : OpcodeTime(executed: 4),
    0x3E : OpcodeTime(executed: 8),
    0x3F : OpcodeTime(executed: 4),
    
    0x40 : OpcodeTime(executed: 4),
    0x41 : OpcodeTime(executed: 4),
    0x42 : OpcodeTime(executed: 4),
    0x43 : OpcodeTime(executed: 4),
    0x44 : OpcodeTime(executed: 4),
    0x45 : OpcodeTime(executed: 4),
    0x46 : OpcodeTime(executed: 8),
    0x47 : OpcodeTime(executed: 4),
    0x48 : OpcodeTime(executed: 4),
    0x49 : OpcodeTime(executed: 4),
    0x4A : OpcodeTime(executed: 4),
    0x4B : OpcodeTime(executed: 4),
    0x4C : OpcodeTime(executed: 4),
    0x4D : OpcodeTime(executed: 4),
    0x4E : OpcodeTime(executed: 8),
    0x4F : OpcodeTime(executed: 4),
    
    0x50 : OpcodeTime(executed: 4),
    0x51 : OpcodeTime(executed: 4),
    0x52 : OpcodeTime(executed: 4),
    0x53 : OpcodeTime(executed: 4),
    0x54 : OpcodeTime(executed: 4),
    0x55 : OpcodeTime(executed: 4),
    0x56 : OpcodeTime(executed: 8),
    0x57 : OpcodeTime(executed: 4),
    0x58 : OpcodeTime(executed: 4),
    0x59 : OpcodeTime(executed: 4),
    0x5A : OpcodeTime(executed: 4),
    0x5B : OpcodeTime(executed: 4),
    0x5C : OpcodeTime(executed: 4),
    0x5D : OpcodeTime(executed: 4),
    0x5E : OpcodeTime(executed: 8),
    0x5F : OpcodeTime(executed: 4),
    
    0x60 : OpcodeTime(executed: 4),
    0x61 : OpcodeTime(executed: 4),
    0x62 : OpcodeTime(executed: 4),
    0x63 : OpcodeTime(executed: 4),
    0x64 : OpcodeTime(executed: 4),
    0x65 : OpcodeTime(executed: 4),
    0x66 : OpcodeTime(executed: 8),
    0x67 : OpcodeTime(executed: 4),
    0x68 : OpcodeTime(executed: 4),
    0x69 : OpcodeTime(executed: 4),
    0x6A : OpcodeTime(executed: 4),
    0x6B : OpcodeTime(executed: 4),
    0x6C : OpcodeTime(executed: 4),
    0x6D : OpcodeTime(executed: 4),
    0x6E : OpcodeTime(executed: 8),
    0x6F : OpcodeTime(executed: 4),
    
    0x70 : OpcodeTime(executed: 8),
    0x71 : OpcodeTime(executed: 8),
    0x72 : OpcodeTime(executed: 8),
    0x73 : OpcodeTime(executed: 8),
    0x74 : OpcodeTime(executed: 8),
    0x75 : OpcodeTime(executed: 8),
    0x76 : OpcodeTime(executed: 4),
    0x77 : OpcodeTime(executed: 8),
    0x78 : OpcodeTime(executed: 4),
    0x79 : OpcodeTime(executed: 4),
    0x7A : OpcodeTime(executed: 4),
    0x7B : OpcodeTime(executed: 4),
    0x7C : OpcodeTime(executed: 4),
    0x7D : OpcodeTime(executed: 4),
    0x7E : OpcodeTime(executed: 8),
    0x7F : OpcodeTime(executed: 4),
    
    0x80 : OpcodeTime(executed: 4),
    0x81 : OpcodeTime(executed: 4),
    0x82 : OpcodeTime(executed: 4),
    0x83 : OpcodeTime(executed: 4),
    0x84 : OpcodeTime(executed: 4),
    0x85 : OpcodeTime(executed: 4),
    0x86 : OpcodeTime(executed: 8),
    0x87 : OpcodeTime(executed: 4),
    0x88 : OpcodeTime(executed: 4),
    0x89 : OpcodeTime(executed: 4),
    0x8A : OpcodeTime(executed: 4),
    0x8B : OpcodeTime(executed: 4),
    0x8C : OpcodeTime(executed: 4),
    0x8D : OpcodeTime(executed: 4),
    0x8E : OpcodeTime(executed: 8),
    0x8F : OpcodeTime(executed: 4),
    
    0x90 : OpcodeTime(executed: 4),
    0x91 : OpcodeTime(executed: 4),
    0x92 : OpcodeTime(executed: 4),
    0x93 : OpcodeTime(executed: 4),
    0x94 : OpcodeTime(executed: 4),
    0x95 : OpcodeTime(executed: 4),
    0x96 : OpcodeTime(executed: 8),
    0x97 : OpcodeTime(executed: 4),
    0x98 : OpcodeTime(executed: 4),
    0x99 : OpcodeTime(executed: 4),
    0x9A : OpcodeTime(executed: 4),
    0x9B : OpcodeTime(executed: 4),
    0x9C : OpcodeTime(executed: 4),
    0x9D : OpcodeTime(executed: 4),
    0x9E : OpcodeTime(executed: 8),
    0x9F : OpcodeTime(executed: 4),
    
    0xA0 : OpcodeTime(executed: 4),
    0xA1 : OpcodeTime(executed: 4),
    0xA2 : OpcodeTime(executed: 4),
    0xA3 : OpcodeTime(executed: 4),
    0xA4 : OpcodeTime(executed: 4),
    0xA5 : OpcodeTime(executed: 4),
    0xA6 : OpcodeTime(executed: 8),
    0xA7 : OpcodeTime(executed: 4),
    0xA8 : OpcodeTime(executed: 4),
    0xA9 : OpcodeTime(executed: 4),
    0xAA : OpcodeTime(executed: 4),
    0xAB : OpcodeTime(executed: 4),
    0xAC : OpcodeTime(executed: 4),
    0xAD : OpcodeTime(executed: 4),
    0xAE : OpcodeTime(executed: 8),
    0xAF : OpcodeTime(executed: 4),
    
    0xB0 : OpcodeTime(executed: 4),
    0xB1 : OpcodeTime(executed: 4),
    0xB2 : OpcodeTime(executed: 4),
    0xB3 : OpcodeTime(executed: 4),
    0xB4 : OpcodeTime(executed: 4),
    0xB5 : OpcodeTime(executed: 4),
    0xB6 : OpcodeTime(executed: 8),
    0xB7 : OpcodeTime(executed: 4),
    0xB8 : OpcodeTime(executed: 4),
    0xB9 : OpcodeTime(executed: 4),
    0xBA : OpcodeTime(executed: 4),
    0xBB : OpcodeTime(executed: 4),
    0xBC : OpcodeTime(executed: 4),
    0xBD : OpcodeTime(executed: 4),
    0xBE : OpcodeTime(executed: 8),
    0xBF : OpcodeTime(executed: 4),
    
    0xC0 : OpcodeTime(executed: 20, notExecuted: 8),
    0xC1 : OpcodeTime(executed: 12),
    0xC2 : OpcodeTime(executed: 16, notExecuted: 12),
    0xC3 : OpcodeTime(executed: 16),
    0xC4 : OpcodeTime(executed: 24, notExecuted: 12),
    0xC5 : OpcodeTime(executed: 16),
    0xC6 : OpcodeTime(executed: 8),
    0xC7 : OpcodeTime(executed: 16),
    0xC8 : OpcodeTime(executed: 20, notExecuted: 8),
    0xC9 : OpcodeTime(executed: 16),
    0xCA : OpcodeTime(executed: 16, notExecuted: 12),
    0xCB : OpcodeTime(executed: 4),
    0xCC : OpcodeTime(executed: 24, notExecuted: 12),
    0xCD : OpcodeTime(executed: 24),
    0xCE : OpcodeTime(executed: 8),
    0xCF : OpcodeTime(executed: 16),
    
    0xD0 : OpcodeTime(executed: 20, notExecuted: 8),
    0xD1 : OpcodeTime(executed: 12),
    0xD2 : OpcodeTime(executed: 16, notExecuted: 12),
    0xD3 : OpcodeTime(executed: 0),
    0xD4 : OpcodeTime(executed: 24, notExecuted: 12),
    0xD5 : OpcodeTime(executed: 16),
    0xD6 : OpcodeTime(executed: 8),
    0xD7 : OpcodeTime(executed: 16),
    0xD8 : OpcodeTime(executed: 20, notExecuted: 8),
    0xD9 : OpcodeTime(executed: 16),
    0xDA : OpcodeTime(executed: 16, notExecuted: 12),
    0xDB : OpcodeTime(executed: 0),
    0xDC : OpcodeTime(executed: 24, notExecuted: 12),
    0xDD : OpcodeTime(executed: 0),
    0xDE : OpcodeTime(executed: 8),
    0xDF : OpcodeTime(executed: 16),
    
    0xE0 : OpcodeTime(executed: 12),
    0xE1 : OpcodeTime(executed: 12),
    0xE2 : OpcodeTime(executed: 8),
    0xE3 : OpcodeTime(executed: 0),
    0xE4 : OpcodeTime(executed: 0),
    0xE5 : OpcodeTime(executed: 16),
    0xE6 : OpcodeTime(executed: 8),
    0xE7 : OpcodeTime(executed: 16),
    0xE8 : OpcodeTime(executed: 16),
    0xE9 : OpcodeTime(executed: 4),
    0xEA : OpcodeTime(executed: 16),
    0xEB : OpcodeTime(executed: 0),
    0xEC : OpcodeTime(executed: 0),
    0xED : OpcodeTime(executed: 0),
    0xEE : OpcodeTime(executed: 8),
    0xEF : OpcodeTime(executed: 16),
    
    0xF0 : OpcodeTime(executed: 12),
    0xF1 : OpcodeTime(executed: 12),
    0xF2 : OpcodeTime(executed: 8),
    0xF3 : OpcodeTime(executed: 4),
    0xF4 : OpcodeTime(executed: 0),
    0xF5 : OpcodeTime(executed: 16),
    0xF6 : OpcodeTime(executed: 8),
    0xF7 : OpcodeTime(executed: 16),
    0xF8 : OpcodeTime(executed: 12),
    0xF9 : OpcodeTime(executed: 8),
    0xFA : OpcodeTime(executed: 16),
    0xFB : OpcodeTime(executed: 4),
    0xFC : OpcodeTime(executed: 0),
    0xFD : OpcodeTime(executed: 0),
    0xFE : OpcodeTime(executed: 8),
    0xFF : OpcodeTime(executed: 16)]

}

class OpcodeTime {
  let executed : UInt16
  let notExecuted : UInt16
  
  init(executed: UInt16, notExecuted : UInt16 = 0) {
    self.executed = executed
    self.notExecuted = notExecuted
  }
}


class InstructionResult {
  let usedCycles : UInt16
  
  init(usedCycles : UInt16) {
    self.usedCycles = usedCycles
  }
  
  convenience init(opcode: UInt8, prefix : UInt8? = nil, executed : Bool = true) {
    var cycles : UInt16
    var times : OpcodeTime
    times = OpcodeTimesContainer.opcodeTimes[Int(opcode)]!
    
    if executed {
      cycles = times.executed
    } else {
      cycles = times.notExecuted
    }
    
    self.init(usedCycles: cycles)
  }
}