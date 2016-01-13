//
//  TopLoopsTableViewDelegate.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.01.16.
//  Copyright © 2016 Maurus Kühne. All rights reserved.
//

import Cocoa

class TopLoopsTableViewDelegate : NSObject, NSTableViewDelegate, NSTableViewDataSource {
  
  let engine = EmulationEngineContainer.sharedEngine
  
  var processedPCCallCountDict : [(UInt16, (count: Int, flags: UInt8))]?
  
  func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
    
    let filtered = engine.positionCountDict.filter { (elem) -> Bool in
      elem.1.count > 2
    }
    
    let sorted = filtered.sort { (a, b) -> Bool in
      return a.1.count > b.1.count
    }
    
    processedPCCallCountDict = sorted
    
    return processedPCCallCountDict?.count ?? 0
  }
  
  func tableView(aTableView: NSTableView, objectValueForTableColumn aTableColumn: NSTableColumn?, row rowIndex: Int) -> AnyObject? {
    
    guard let processedPCCallCountDict = processedPCCallCountDict else { return nil }
    
    
    let idx = processedPCCallCountDict.startIndex.advancedBy(rowIndex)
    if aTableColumn?.identifier == "loop pos" {
      return NSString(format: "0x%X", processedPCCallCountDict[idx].0)
    } else {
      return NSString(format: "0x%X", processedPCCallCountDict[idx].1.count)
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
