//
//  ADDTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 20.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class ADCTests: XCTestCase {
  
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
  
  func test8BitAdd() {
    
    ctx.registers.Flags.setFlag(Flags.Carry)
    ctx.registers.A = 0x5
    ctx.registers.B = 0x7
    
    ctx.registers.Flags.setFlag(Flags.Subtract)
    
    let regToWrite = RegisterDataLocation(register: Register.A)
    let regToAdd = RegisterDataLocation(register: Register.B)
    
    let instruction = ADC(opcode: 0, registerToStore: regToWrite, registerToAdd: regToAdd)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(13), "could not add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Subtract), "Subtract Flag was not reset after ADC")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is set after overflow")
    
    ctx.registers.A = 0x8
    ctx.registers.B = 0xFF
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(7), "could not add two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is not set after overflow")
    
    ctx.registers.A = 0x0
    ctx.registers.B = 0x0
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(1), "could not add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is not reset after normal add")
    
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
  
  func test16BitAdd() {
    
    ctx.registers.Flags.setFlag(Flags.Carry)
    
    ctx.registers.BC = 0x01F4
    ctx.registers.DE = 0x02BC
    
    ctx.registers.Flags.setFlag(Flags.Subtract)
    
    let regToWrite = RegisterDataLocation(register: Register.BC)
    let regToAdd = RegisterDataLocation(register: Register.DE)
    
    let instruction = ADC(opcode: 0, registerToStore: regToWrite, registerToAdd: regToAdd)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.BC, UInt16(0x4B1), "could not add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Subtract), "Subtract Flag was not reset after ADC")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is set after overflow")
    
    ctx.registers.BC = 0x8
    ctx.registers.DE = 0xFFFF
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.BC, UInt16(7), "could not add two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is not set after overflow")
    
    ctx.registers.BC = 0x0
    ctx.registers.DE = 0x0
    ctx.registers.Flags.setFlag(Flags.Zero)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.BC, UInt16(1), "could not add two registers")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(Flags.Carry), "Carry Flag is not reset after normal add")
    
    ctx.registers.BC = 0x0FFF
    ctx.registers.DE = 0x0001
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.BC, UInt16(0x1000), "could not add two registers")
    XCTAssert(ctx.registers.Flags.isFlagSet(Flags.HalfCarry), "HalfCarry Flag is not set after carry from bit 11 to 12")
  }
}
