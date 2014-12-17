//
//  BitInstructions.swift
//  GBEmu
//
//  Created by Maurus Kühne on 17.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation
import XCTest

class BitInstructionTests : XCTestCase {
  
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
  
  func testBIT() {
    
    ctx.registers.A = 0b0000_0100
    
    let loc = RegisterDataLocation(register: Register.A)
    let instr = BIT(opcode : 0x0, prefix : 0x0, register : loc, bitPosition : 2)
    
    instr.execute(ctx)
    
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(.Zero), "could not test bit in Register A")
    
    ctx.registers.A = 0
    
    instr.execute(ctx)
    
    XCTAssert(ctx.registers.Flags.isFlagSet(.Zero), "could not test bit in Register A")
  }
  
  func testSET() {
    
    ctx.registers.A = 0
    
    let loc = RegisterDataLocation(register: Register.A)
    let instr = SET(opcode : 0x0, prefix : 0x0, register : loc, bitPosition : 2)
    
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(4), "could not set bit in Register A")
  }
  
  func testRES() {
    
    ctx.registers.A = 0b0000_0100
    
    let loc = RegisterDataLocation(register: Register.A)
    let instr = RES(opcode : 0x0, prefix : 0x0, register : loc, bitPosition : 2)
    
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0), "could not set bit in Register A")
  }
}