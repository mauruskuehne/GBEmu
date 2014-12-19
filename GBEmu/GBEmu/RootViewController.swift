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
  private let engine = EmulationEngineContainer.sharedEngine
  
  @IBOutlet var registerTableViewDataSource: RegisterTableViewDelegate!
  
  @IBOutlet weak var registerTableView: NSTableView!
  @IBOutlet weak var memoryTableView: NSTableView!
  @IBOutlet weak var opcodeTableView: NSTableView!
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
    memoryTableView.reloadData()
    
    jumpToMemoryLocation()
  }
  
  func executedInstruction(engine: EmulationEngine, instruction: Instruction) {
    
    if !isROMLoaded {
      let alert = NSAlert()
      alert.messageText = "You have to load a ROM, before you can start running the rom!"
    }
    
    let nextInstruction = engine.readNextInstruction()
    
    registerTableView.reloadData()
    
    lastInstructionLabel.stringValue = instruction.description
    
    println(lastInstructionLabel.stringValue)
    
    nextInstructionLabel.stringValue = nextInstruction.instruction.description
    
    jumpToMemoryLocation()
  }
  
  func jumpToMemoryLocation() {
    memoryTableView.scrollRowToVisible(Int(engine.registers.PC +  3))
    memoryTableView.selectRowIndexes(NSIndexSet(index: Int(engine.registers.PC)), byExtendingSelection: false)
  }
  
  @IBAction func runNextFrame(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeNextFrame()
  }
  
  @IBAction func runToVSync(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeToVSync()
  }
  @IBAction func executeNextInstruction(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeNextInstruction()
  }
  @IBAction func runToRet(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeToRet()
  }
}

