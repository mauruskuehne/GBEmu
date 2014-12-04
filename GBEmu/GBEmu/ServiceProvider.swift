//
//  ServiceProvider.swift
//  GBEmu
//
//  Created by Maurus Kühne on 04/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation


class ServiceProvider {
  
  var services = [AnyObject]()
  
  func registerService<T : AnyObject>(service : T) {
    services.append(service)
  }
  
  func getService<T : AnyObject>() -> T? {
    
    var service : AnyObject? = nil
    
    for x in services {
      if x is T {
        service = x;
      }
    }
    
    return service as T?;
  }
  
  init() {
  }
}