//
//  ADDTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 20.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class ADDTests: XCTestCase {
  
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
  
  func test8BitAdd() {
    
    ctx.registers.A = 0x5
    ctx.registers.B = 0x7
    
    ctx.registers.Flags.setFlag(Flags.Subtract)
    
    let regToWrite = RegisterDataLocation(register: Register.A)
    let regToAdd = RegisterDataLocation(register: Register.B)
    
    let instruction = ADD(registerToStore: regToWrite, registerToAdd: regToAdd)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(12), "could not add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Subtract), "Subtract Flag was not reset after ADD")
    
    ctx.registers.A = 0x8
    ctx.registers.B = 0xFF
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(7), "could not add two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is not set after overflow")
    
    ctx.registers.A = 0x0
    ctx.registers.B = 0x0
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0), "could not add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is not reset after normal add")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Zero), "Zero Flag is not set after adding 0 to 0")
    
    ctx.registers.A = 0x0F
    ctx.registers.B = 0x01
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0x10), "could not add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Zero), "Zero Flag is not reset after normal add")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.HalfCarry), "HalfCarry Flag is not set after carry from bit 3 to 4")
    
    ctx.registers.A = 0x01
    ctx.registers.B = 0x01
    
    instruction.execute(ctx)
    
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.HalfCarry), "HalfCarry Flag is not reset after normal add")
  }
  
  func testSignedAdd() {
    
    ctx.registers.SP = 100
    
    ctx.registers.Flags.setFlag(Flags.Subtract)
    
    let regToWrite = RegisterDataLocation(register: Register.SP)
    var regToAdd = ConstantDataLocation(value: sint8(-10))
    
    var instruction = ADD(registerToStore: regToWrite, registerToAdd: regToAdd)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.SP, UInt16(90), "could not signed add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Subtract), "Subtract Flag was not reset after ADD")
    
  }
  
  func test16BitAdd() {
    
    ctx.registers.BC = 0x01F4
    ctx.registers.DE = 0x02BC
    
    ctx.registers.Flags.setFlag(Flags.Subtract)
    
    let regToWrite = RegisterDataLocation(register: Register.BC)
    let regToAdd = RegisterDataLocation(register: Register.DE)
    
    let instruction = ADD(registerToStore: regToWrite, registerToAdd: regToAdd)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.BC, UInt16(0x4B0), "could not add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Subtract), "Subtract Flag was not reset after ADD")
    
    ctx.registers.BC = 0x8
    ctx.registers.DE = 0xFFFF
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.BC, UInt16(7), "could not add two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is not set after overflow")
    
    ctx.registers.BC = 0x0
    ctx.registers.DE = 0x0
    ctx.registers.Flags.setFlag(Flags.Zero)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.BC, UInt16(0), "could not add two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Zero), "Zero Flag should not be reset after 16bit ADD")
    
    ctx.registers.BC = 0x0FFF
    ctx.registers.DE = 0x0001
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.BC, UInt16(0x1000), "could not add two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.HalfCarry), "HalfCarry Flag is not set after carry from bit 11 to 12")
  }
}
