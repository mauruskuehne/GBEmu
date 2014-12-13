//
//  ViewController.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa

class RootViewController: NSViewController, EmulationEngineDelegate {

  private var isROMLoaded = false
  
  @IBOutlet var registerTableViewDataSource: RegisterTableViewDelegate!
  
  @IBOutlet weak var registerTableView: NSTableView!
  @IBOutlet weak var lastInstructionLabel: NSTextField!
  @IBOutlet weak var nextInstructionLabel: NSTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    EmulationEngineContainer.sharedEngine.delegate = self
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  func engineDidLoadRom(engine: EmulationEngine) {
    isROMLoaded = true
    registerTableView.reloadData()
  }
  
  func executedInstruction(engine: EmulationEngine, instruction: Instruction) {
    
    if !isROMLoaded {
      let alert = NSAlert()
      alert.messageText = "You have to load a ROM, before you can start running the rom!"
    }
    
    let nextInstruction = engine.readNextInstruction()
    
    registerTableView.reloadData()
    
    lastInstructionLabel.stringValue = instruction.description
    nextInstructionLabel.stringValue = nextInstruction.instruction.description
  }
  
  @IBAction func runNextStep(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeNextStep()
  }
}

