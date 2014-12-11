//
//  RegisterTableViewDelegate.swift
//  GBEmu
//
//  Created by Maurus Kühne on 02/12/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//
import AppKit
import Cocoa

class RegisterTableViewDelegate : NSObject, NSTableViewDelegate, NSTableViewDataSource {
  
  func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
    if EmulationEngineContainer.sharedEngine.registers == nil {
      return 0;
    } else {
      return 14
    }
  }
  
  func tableView(aTableView: NSTableView, objectValueForTableColumn aTableColumn: NSTableColumn?, row rowIndex: Int) -> AnyObject? {
    
    if EmulationEngineContainer.sharedEngine.registers == nil {
      return nil
    }
    
    if let column = aTableColumn {
      
      let reg = Register(rawValue: rowIndex)!
      
      if column.identifier == "Register" {
        return reg.description
      } else {
        
        var number : NSNumber = 0
        var format = "0x%0X"
        if rowIndex >= 8 {
          number = NSNumber(unsignedShort: EmulationEngineContainer.sharedEngine.registers[reg].getAsUInt16())
          format = "0x%04X"
        } else {
          number = NSNumber(unsignedChar: EmulationEngineContainer.sharedEngine.registers[reg].getAsUInt8())
          
        }
        
        let txt = String(format: "%X", number)
        
        return txt
      }
    }
    
    return "UNDEFINED"
  }
  
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    //NSTableCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    let res : NSTableCellView! = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as NSTableCellView
    
    let val : AnyObject = self.tableView(tableView, objectValueForTableColumn: tableColumn, row: row)!
    
    res.textField?.stringValue = "\(val)"
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    //result.textField.stringValue = [self.nameArray objectAtIndex:row];
    
    // Return the result
    //return result;
    
    return res
  }
}
