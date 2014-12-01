//
//  RETTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 01.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class RETTests: XCTestCase {
  
  var ctx : ExecutionContext!
  
  override func setUp() {
    super.setUp()
    
    let regs = Registers()
    
    var data = NSMutableData(length: 0xFFFF)
    
    let memory = MemoryAccessor(rom: NSData(data: data!) )
    
    ctx = ExecutionContext(registers: regs, memoryAccess: memory)
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testRET() {
    let oldPCValue : UInt16 = 0x100
    ctx.registers.PC = oldPCValue
    
    let adrToCall = ConstantDataLocation(value: UInt16(0x200))
    
    let callInstr = CALL(addressToCall: adrToCall, condition: nil)
    callInstr.execute(ctx)
    
    let retInstr = RET()
    retInstr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.PC, oldPCValue + 1, "could not return from call")
    
  }
  
}
