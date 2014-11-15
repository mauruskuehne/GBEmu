//
//  LD.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class LD : Instruction {
  
  let readLocation : ReadableDataLocation
  let writeLocation : WriteableDataLocation
  
  override var description : String {
    get {
      return "LD \(writeLocation), \(readLocation)"
    }
  }
  
  init(readLocation : ReadableDataLocation, writeLocation : WriteableDataLocation) {
    self.readLocation = readLocation
    self.writeLocation = writeLocation
    
  }
  
  override func execute(context : ExecutionContext) {
    
    let val = readLocation.read(context)
    
    writeLocation.write(val, context: context)
  }
}
