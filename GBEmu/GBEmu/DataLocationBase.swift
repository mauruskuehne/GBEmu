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
  func getAsSInt8() -> sint8
  func getAsUInt16() -> UInt16
  func getAsInt32() -> Int32
  
  var isSigned : Bool { get }
}

protocol DataLocationBase : CustomStringConvertible{
}

protocol WriteableDataLocation : DataLocationBase {
  func write(value : DataLocationSupported, context : ExecutionContext)
}

protocol ReadableDataLocation : DataLocationBase {
  func read(context : ExecutionContext) -> DataLocationSupported
}

protocol ReadWriteDataLocation : DataLocationBase, WriteableDataLocation, ReadableDataLocation {
  
}