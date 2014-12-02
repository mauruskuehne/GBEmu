//
//  ViewController.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  @IBOutlet var registerTableViewDataSource: RegisterTableViewDelegate!
  
  @IBOutlet weak var registerTableView: NSTableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  
}

