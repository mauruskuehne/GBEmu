//
//  JPTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 27.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class JPTests: XCTestCase {
  
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
  
  func testJumps() {
    
    ctx.registers.PC = 0x100
    ctx.registers.HL = 0x200
    let loc = RegisterDataLocation(register: Register.HL)
    
    var instruction = JP(locationToRead: loc, isRelative: false)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.PC, {0x200}(), "could not jump to location 0x200")
    
    instruction = JP(locationToRead: loc, isRelative: true)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.PC, {0x400}(), "could not relative jump to location 0x400")
  }
  
  func testConditions() {
    
    ctx.registers.PC = 0x100
    ctx.registers.HL = 0x200
    let loc = RegisterDataLocation(register: Register.HL)
    ctx.registers.Flags.resetFlag(Flags.Carry)
    var instruction = JP(locationToRead: loc, condition: JumpCondition.Carry)
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.PC, {0x100}(), "Condition has been ignored")
    
    ctx.registers.Flags.setFlag(Flags.Carry)
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.PC, {0x200}(), "condition has been ignored")
  }
}
