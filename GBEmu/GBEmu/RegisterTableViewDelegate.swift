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
  
  var register : Registers!
  
  func displayRegisterData(register : Registers) {
    self.register = register
  }
  
  func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
    if register == nil {
      return 0;
    } else {
      return 14
    }
  }
  
  func tableView(aTableView: NSTableView, objectValueForTableColumn aTableColumn: NSTableColumn?, row rowIndex: Int) -> AnyObject? {
    
    if register == nil {
      return nil
    }
    
    if let column = aTableColumn {
      
      let reg = Register(rawValue: rowIndex)!
      
      if column.identifier == "Register" {
        return reg.description
      } else {
        if rowIndex >= 8 {
          return NSNumber(unsignedShort: register[reg].getAsUInt16())
        } else {
          return NSNumber(unsignedChar: register[reg].getAsUInt8())
        }
        
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
