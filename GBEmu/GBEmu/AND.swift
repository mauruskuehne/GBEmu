//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class AND : Instruction {
  
  let register : ReadableDataLocation
  
  override var description : String {
    get {
      return "AND \(register)"
    }
  }
  
  init(register : ReadableDataLocation) {
    self.register = register
  }
  
  override func execute(context : ExecutionContext) {
    
    assertionFailure("not yet implemented")
    
  }
}