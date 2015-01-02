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
  
  @IBOutlet weak var displayView: DisplayView!
  @IBOutlet weak var registerTableView: NSTableView!
  @IBOutlet weak var memoryTableView: NSTableView!
  @IBOutlet weak var opcodeTableView: NSTableView!
  @IBOutlet weak var lastInstructionLabel: NSTextField!
  @IBOutlet weak var nextInstructionLabel: NSTextField!
  @IBOutlet weak var txtPCBreakpoint: NSTextField!
  
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
    
    updateTables()
  }
  
  func frameCompleted(engine: EmulationEngine) {
    
    displayView.refresh()
  }
  
  func executedInstruction(engine: EmulationEngine, instruction: Instruction) {
    
    if !isROMLoaded {
      let alert = NSAlert()
      alert.messageText = "You have to load a ROM, before you can start running the rom!"
    }
  }
  
  func updateTables() {
    registerTableView.reloadData()
    
    memoryTableView.scrollRowToVisible(Int(engine.registers.PC +  3))
    memoryTableView.selectRowIndexes(NSIndexSet(index: Int(engine.registers.PC)), byExtendingSelection: false)
    
    let nextInstruction = engine.readNextInstruction()
    
    lastInstructionLabel.stringValue = nextInstructionLabel.stringValue
    
    nextInstructionLabel.stringValue = nextInstruction.instruction.description
  }
  
  @IBAction func runNextFrame(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeNextFrame()
    
    updateTables()
  }
  
  @IBAction func runToVSync(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeToVSync()
    
    updateTables()
  }
  @IBAction func executeNextInstruction(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeNextInstruction()
    
    updateTables()
  }
  @IBAction func runToRet(sender: AnyObject) {
    EmulationEngineContainer.sharedEngine.executeToRet()
    
    updateTables()
  }
  
  @IBAction func runToPC(sender: AnyObject) {
    
    let scanner = NSScanner(string: txtPCBreakpoint.stringValue)
    var res : UInt32 = 0
    if scanner.scanHexInt(&res) {
      EmulationEngineContainer.sharedEngine.executeToAddress(UInt16(res))
    } else {
      let alert = NSAlert()
      alert.messageText = "The entered address is not a valid HEX address"
    }
    
    updateTables()
  }
}

