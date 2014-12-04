//
//  WeakContainer.swift
//  GBEmu
//
//  Created by Maurus Kühne on 04/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

struct WeakContainer<T : AnyObject> {
  weak var _value : AnyObject?
  
  init (value: T) {
    _value = value
  }
  
  func get() -> T? {
    return _value as T?
  }
}