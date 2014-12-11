//
//  ViewController.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa

class RootViewController: NSViewController, EmulationEngineDelegate {

  @IBOutlet var registerTableViewDataSource: RegisterTableViewDelegate!
  
  @IBOutlet weak var registerTableView: NSTableView!
  @IBOutlet weak var lastInstructionLabel: NSTextField!
  
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
    
    registerTableView.reloadData()
  }
  
  func executedInstruction(engine: EmulationEngine, instruction: Instruction) {
    
    registerTableView.reloadData()
    
    lastInstructionLabel.stringValue = instruction.description
  }
  
  @IBAction func runNextStep(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeNextStep()
  }
}

