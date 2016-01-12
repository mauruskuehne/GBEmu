//
//  RegisterTableViewDelegate.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//
import AppKit
import Cocoa

class OpcodeTableViewDelegate : NSObject, NSTableViewDelegate, NSTableViewDataSource {
  
  let engine = EmulationEngineContainer.sharedEngine
  
  func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
    return 0x0
  }
  
  func tableView(aTableView: NSTableView, objectValueForTableColumn aTableColumn: NSTableColumn?, row rowIndex: Int) -> AnyObject? {
    if aTableColumn?.identifier == "address" {
      return rowIndex
    } else {
      return engine.memoryAccess.readUInt8(UInt16(rowIndex)).description
    }
  }
  
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    //NSTableCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    let res : NSTableCellView! = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
    
    let val : AnyObject = self.tableView(tableView, objectValueForTableColumn: tableColumn, row: row)!
    
    res.textField?.stringValue = "\(val)"
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    //result.textField.stringValue = [self.nameArray objectAtIndex:row];
    
    // Return the result
    //return result;
    
    return res
  }
}
