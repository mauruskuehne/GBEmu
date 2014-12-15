//
//  ConstantDataLocation.swift
//  GBEmu
//
//  Created by Maurus Kühne on 16.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class ConstantDataLocation : ReadableDataLocation {
  
  let constantValue : DataLocationSupported
  
  init(value : DataLocationSupported) {
    constantValue = value
  }
  
  func read(context : ExecutionContext) -> DataLocationSupported {
    return constantValue
  }
  
  var description: String {
    get {
      
      var str : String!
      
      if let val = constantValue as? UInt8 {
        str = String(format: "0x%X", constantValue.getAsUInt8())
      } else if let val = constantValue as? sint8 {
        str = String(format: "%d[dec]", constantValue.getAsSInt8())
      } else if let val = constantValue as? UInt16 {
        str = String(format: "0x%X", constantValue.getAsUInt16())
      } else {
        str = String(format: "0x%X", constantValue.getAsInt32())
      }
    
      
      return str
    }
  }
}