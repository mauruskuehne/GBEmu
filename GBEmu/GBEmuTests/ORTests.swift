//
//  ANDTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 26/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class ORTests: XCTestCase {
  
  var ctx : ExecutionContext!
  
  override func setUp() {
    super.setUp()
    
    let regs = Registers()
    
    let data = NSMutableData(length: 0xFFFF)
    
    let memory = MemoryAccessor()
    memory.loadRom(NSData(data: data!))
    
    ctx = ExecutionContext(registers: regs, memoryAccess: memory)
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testOR() {
    ctx.registers.A = 0x03
    ctx.registers.B = 0x05
    
    let reg = RegisterDataLocation(register: Register.B)
    
    let instruction = OR(opcode: 0, register: reg)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, {0x07}(), "could not logically OR values")
  }
  
}
