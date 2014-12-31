//
//  DisplayView.swift
//  GBEmu
//
//  Created by Maurus Kühne on 19.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa

class DisplayView : NSView {
  
  let engine = EmulationEngineContainer.sharedEngine
  let display = EmulationEngineContainer.sharedEngine.display
  
  func refresh() {
    super.needsDisplay = true
  }
  
  override func drawRect(dirtyRect: NSRect) {
    NSColor.redColor().set()
    NSRectFill(dirtyRect)
  }
}