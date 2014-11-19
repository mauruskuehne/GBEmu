//
//  DataLocationBase.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

protocol DataLocationSupported {
  
  func getAsUInt8() -> UInt8
  func getAsUInt16() -> UInt16
}

extension UInt8 : DataLocationSupported {
  
  func getAsUInt8() -> UInt8 {
    return self
  }
  
  func getAsUInt16() -> UInt16 {
    return UInt16(self)
  }

}

extension UInt16 : DataLocationSupported {
  func getAsUInt8() -> UInt8 {
    return self.toBytes().lower
  }
  
  func getAsUInt16() -> UInt16 {
    return self

  }
}

protocol DataLocationBase : Printable{
}

protocol WriteableDataLocation : DataLocationBase {
  func write(value : DataLocationSupported, context : ExecutionContext)
}

protocol ReadableDataLocation : DataLocationBase {
  func read(context : ExecutionContext) -> DataLocationSupported
}

protocol ReadWriteDataLocation : DataLocationBase, WriteableDataLocation, ReadableDataLocation {
  
}