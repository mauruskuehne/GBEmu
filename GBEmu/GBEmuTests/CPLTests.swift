//
//  CPLTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 01.01.15.
//  Copyright (c) 2015 Maurus Kühne. All rights reserved.
//

import Foundation
import XCTest

class CPLTests : XCTestCase {
  
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
  
  func testCPL() {
    
    ctx.registers.A = 0b0000_0100
    
    let instr = CPL(opcode: 0)
    
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, {0b1111_1011}(), "could not create complement from register A")
    
    XCTAssert(ctx.registers.Flags.isFlagSet(.HalfCarry), "HalfCarry Flag not set after CPL")
    
    XCTAssert(ctx.registers.Flags.isFlagSet(.Subtract), "Subtract Flag not set after CPL")
  }
}