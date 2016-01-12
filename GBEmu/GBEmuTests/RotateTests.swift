//
//  RETTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 01.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class RotateTests: XCTestCase {
  
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
  
  func testRLCA() {
    
    ctx.registers.A = 0b1000_0000
    
    let loc = RegisterDataLocation(register: Register.A)
    let instr = RLC(opcode: 0, register: loc)
    
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, { 0b0000_0001 }(), "could not rotate register A")
    XCTAssert(ctx.registers.Flags.isFlagSet(.Carry), "could not rotate register A")
    
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, { 0b0000_0010 }(), "could not rotate register A")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(.Carry), "could not rotate register A")
  }
  
  func testRLA() {
    
    ctx.registers.A = 0b1000_0000
    
    let loc = RegisterDataLocation(register: Register.A)
    let instr = RL(opcode: 0, register: loc)
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, { 0b0000_0000 }(), "could not rotate register A")
    XCTAssert(ctx.registers.Flags.isFlagSet(.Carry), "could not rotate register A")
    
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, { 0b0000_0001 }(), "could not rotate register A")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(.Carry), "could not rotate register A")
  }
  
  func testRRCA() {
    
    ctx.registers.A = 0b0000_0001
    
    let loc = RegisterDataLocation(register: Register.A)
    let instr = RRC(opcode: 0, register: loc)
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, { 0b1000_0000 }(), "could not left rotate register A")
    XCTAssert(ctx.registers.Flags.isFlagSet(.Carry), "could not left rotate register A")
    
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, { 0b0100_0000 }(), "could not left rotate register A")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(.Carry), "could not left rotate register A")
  }
  
  func testRRA() {
    
    ctx.registers.A = 0b0000_0001
    ctx.registers.Flags.resetFlag(.Carry)
    
    let loc = RegisterDataLocation(register: Register.A)
    let instr = RR(opcode: 0, register: loc)
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, { 0b0000_0000 }(), "could not rotate register A")
    XCTAssert(ctx.registers.Flags.isFlagSet(.Carry), "could not rotate register A")
    
    instr.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, { 0b1000_0000 }(), "could not rotate register A")
    XCTAssertFalse(ctx.registers.Flags.isFlagSet(.Carry), "could not rotate register A")
  }
}
