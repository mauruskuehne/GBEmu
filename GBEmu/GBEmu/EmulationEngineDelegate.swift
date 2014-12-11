//
//  EmulationEngineDelegate.swift
//  GBEmu
//
//  Created by Maurus Kühne on 10.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

protocol EmulationEngineDelegate {
  
  func engineDidLoadRom(engine : EmulationEngine)
  
}