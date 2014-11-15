//
//  Opcodes.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class Instruction : Printable{
  
  
  var description: String {
    get {
      return "unknown instruction"
    }
  }
  
  
  func execute(context : ExecutionContext) {
    
  }
  
}