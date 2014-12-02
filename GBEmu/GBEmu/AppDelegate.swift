//
//  AppDelegate.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  let engine : EmulationEngine
  
  override init() {
    
    engine = EmulationEngine()
    
    super.init()
    
  }
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Insert code here to initialize your application
    
    
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }
  
  func openDocument(sender : NSObject) {
    
    let panel = NSOpenPanel()
    panel.runModal()
    
    if let url = panel.URL {
      let data = NSData(contentsOfURL: url)
      
      engine.loadRom(data!)
    }
  }

}
