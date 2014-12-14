//
//  ADDTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 20.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class CPTests: XCTestCase {
  
  var ctx : ExecutionContext!
  
  override func setUp() {
    super.setUp()
    
    let regs = Registers()
    
    var data = NSMutableData(length: 0xFFFF)
    
    let memory = MemoryAccessor()
    memory.loadRom(NSData(data: data!))
    
    ctx = ExecutionContext(registers: regs, memoryAccess: memory)
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCP() {
    
    ctx.registers.A = 0x7
    ctx.registers.B = 0x5
    
    ctx.registers.Flags.setFlag(Flags.Subtract)
    
    let regToSub = RegisterDataLocation(register: Register.B)
    
    let instruction = CP(register: regToSub)
    
    instruction.execute(ctx)
    
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Zero), "could not compare two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Subtract), "Subtract Flag was not set after CP")
    
    ctx.registers.A = 0x8
    ctx.registers.B = 0x8
    
    instruction.execute(ctx)
    
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Subtract), "Zero flag not set when values are equal")
    
    
    ctx.registers.A = 0x10
    ctx.registers.B = 0x01
    
    instruction.execute(ctx)
    
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.HalfCarry), "HalfCarry Flag is set after borrow from bit 4 to bit 3")
  }
}
