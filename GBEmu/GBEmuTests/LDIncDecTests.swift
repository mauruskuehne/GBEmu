//
//  LDTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 19.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class LDIncDecTests: XCTestCase {
  
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
  
  func testInc() {
    
    ctx.registers.HL = 0x0
    
    let read = RegisterDataLocation(register: Register.HL, dereferenceFirst: true)
    let write = RegisterDataLocation(register: Register.A)
    
    let instruction = LDIncDec(opcode: 0, readLocation: read, writeLocation: write, operation : .Inc)
    
    instruction.execute(ctx)
    
    XCTAssertEqual({ 0x1 }(), ctx.registers.HL, "could not load value to register")
  }
  
  func testDec() {
    
    ctx.registers.HL = 0x2
    
    let write = RegisterDataLocation(register: Register.HL, dereferenceFirst: true)
    let read = RegisterDataLocation(register: Register.A)
    
    let instruction = LDIncDec(opcode: 0, readLocation: read, writeLocation: write, operation : .Dec)
    
    instruction.execute(ctx)
    
    XCTAssertEqual({ 0x1 }(), ctx.registers.HL, "could not load value to register")
  }
}
