//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class SUB : Instruction {
  
  let registerToStore : ReadWriteDataLocation
  let registerToSubtract : ReadableDataLocation
  
  override var description : String {
    get {
      return "SUB \(registerToStore), \(registerToSubtract)"
    }
  }
  
  init(registerToStore : ReadWriteDataLocation, registerToSubtract : ReadableDataLocation) {
    self.registerToStore = registerToStore
    self.registerToSubtract = registerToSubtract
  }
  
  override func execute(context : ExecutionContext) {
    
    
    assertionFailure("not yet implemented")
    
    
  }
}