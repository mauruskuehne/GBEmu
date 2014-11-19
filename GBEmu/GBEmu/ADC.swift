//
//  ADD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class ADC : Instruction {
  
  let registerToStore : ReadWriteDataLocation
  let registerToAdd : ReadableDataLocation
  
  override var description : String {
    get {
      return "ADC \(registerToStore), \(registerToAdd)"
    }
  }
  
  init(registerToStore : ReadWriteDataLocation, registerToAdd : ReadableDataLocation) {
    self.registerToStore = registerToStore
    self.registerToAdd = registerToAdd
  }
  
  override func execute(context : ExecutionContext) {
    
    
    assertionFailure("not yet implemented")
    
    
  }
}