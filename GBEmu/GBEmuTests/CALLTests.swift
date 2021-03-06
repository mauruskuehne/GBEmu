//
//  CALLTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 01.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//


import Cocoa
import XCTest

class CALLTests: XCTestCase {
  
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
  
  func testCALL() {
    
    let val : UInt8 = 100
    let oldPC : UInt16 = 200
    ctx.registers.PC = oldPC
    
    ctx.registers.SP = 500
    
    let adrLoc = ConstantDataLocation(value: val)
    
    let instruction = CALL(opcode: 0, addressToCall: adrLoc)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.PC, UInt16(val), "could not set PC")
    
    let valAtSP : UInt16 = ctx.memoryAccess.readUInt16(ctx.registers.SP)
    
    XCTAssertEqual(valAtSP, oldPC, "did not correctly store return location in SP")
  }
  
}
