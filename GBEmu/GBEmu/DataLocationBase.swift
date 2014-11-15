//
//  DataLocationBase.swift
//  GBEmu
//
//  Created by Maurus Kühne on 15.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

protocol DataLocationSupported { }

extension UInt8 : DataLocationSupported {}
extension UInt16 : DataLocationSupported {}

protocol DataLocationBase : Printable{
}

protocol WriteableDataLocation : DataLocationBase {
  func write(value : DataLocationSupported, context : ExecutionContext)
}

protocol ReadableDataLocation : DataLocationBase {
  func read(context : ExecutionContext) -> DataLocationSupported
}