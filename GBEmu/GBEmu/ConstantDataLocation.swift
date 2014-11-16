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
      return "\(constantValue)"
    }
  }
}