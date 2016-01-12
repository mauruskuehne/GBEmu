//
//  ADDTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 20.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class SBCTests: XCTestCase {
  
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
  
  func test8BitSub() {
    
    ctx.registers.A = 0x7
    ctx.registers.B = 0x5
    
    ctx.registers.Flags.setFlag(Flags.Carry)
    
    let regToWrite = RegisterDataLocation(register: Register.A)
    let regToSub = RegisterDataLocation(register: Register.B)
    
    let instruction = SBC(opcode: 0, registerToStore: regToWrite, registerToSubtract: regToSub)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0x1), "could not substract two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Subtract), "Subtract Flag was not set after SBC")
    
    ctx.registers.A = 0x0
    ctx.registers.B = 0x8
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0xF8), "could not subtract two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is not set after underflow")
    
    ctx.registers.A = 0x1
    ctx.registers.B = 0x0
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0), "could not subtract two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Zero), "Zero Flag is not set after subtracting 0 from 0")
    
    ctx.registers.A = 0x10
    ctx.registers.B = 0x01
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0xF), "could not subtract two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.HalfCarry), "HalfCarry Flag is not set after borrow from bit 4 to bit 3")
  }
}
