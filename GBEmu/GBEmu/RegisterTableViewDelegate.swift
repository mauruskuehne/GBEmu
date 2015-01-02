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
    return 19
  }
  
  func tableView(aTableView: NSTableView, objectValueForTableColumn aTableColumn: NSTableColumn?, row rowIndex: Int) -> AnyObject? {
    
    if rowIndex >= 18 {
      if aTableColumn?.identifier == "Register" {
        return "LCDC"
      } else {
        return String(format: "0x%X", EmulationEngineContainer.sharedEngine.memoryAccess[IORegister.LCDC.rawValue])
      }
    } else if rowIndex >= 14 {
      var flag : Flags
      
      switch rowIndex {
      case 14:
        flag = .Carry
      case 15:
        flag = .HalfCarry
      case 16:
        flag = .Subtract
      case 17:
        flag = .Zero
      default :
        assertionFailure("unknown flag!")
      }
      
      if aTableColumn?.identifier == "Register" {
        return flag.description
      } else {
        return EmulationEngineContainer.sharedEngine.registers.Flags.isFlagSet(flag)
      }
    } else {
      let reg = Register(rawValue: rowIndex)!
      
      
      if aTableColumn?.identifier == "Register" {
        return reg.description
      } else {
        
        var number : NSNumber = 0
        var format : String
        if rowIndex >= 8 {
          number = NSNumber(unsignedShort: EmulationEngineContainer.sharedEngine.registers[reg].getAsUInt16())
          format = "0x%X"
        } else {
          number = NSNumber(unsignedChar: EmulationEngineContainer.sharedEngine.registers[reg].getAsUInt8())
          format = "0x%X"
        }
        
        var txt : String
        if aTableColumn?.identifier == "HexVal" {
          txt = String(format: format, number.intValue)
        } else {
          txt = number.stringValue
        }
        
        return txt
      }
      
    }
    
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
