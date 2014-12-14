//
//  LDTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 19.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class LDTests: XCTestCase {
  
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
  
  func test8BitRegisterLoad() {
    
    let valToStore = ConstantDataLocation(value: UInt8(7))
    let regToBeLoaded = RegisterDataLocation(register: Register.A)
    
    let instruction = LD(readLocation: valToStore, writeLocation: regToBeLoaded)
    
    XCTAssertEqual("LD A, 0x7", instruction.description, "wrong description")
    
    instruction.execute(ctx)
    
    XCTAssertEqual({ 7 }(), ctx.registers.A, "could not load value to register")
  }
  
  func test16BitRegisterLoad() {
    
    let valToStore = ConstantDataLocation(value: UInt16(800))
    let regToBeLoaded = RegisterDataLocation(register: Register.HL)
    
    let instruction = LD(readLocation: valToStore, writeLocation: regToBeLoaded)
    
    XCTAssertEqual("LD HL, 0x320", instruction.description, "wrong description")
    
    instruction.execute(ctx)
    
    XCTAssertEqual({ 800 }(), ctx.registers.HL, "could not load value to register")
  }
  
  func testDereferencedRegisterLoad() {
    
    let memoryAddress : UInt16 = 0x1000
    ctx.registers.HL = memoryAddress
    
    let valToStore = ConstantDataLocation(value: UInt16(250))
    let regToBeLoaded = RegisterDataLocation(register: Register.HL, dereferenceFirst : true)
    
    let instruction = LD(readLocation: valToStore, writeLocation: regToBeLoaded)
    
    XCTAssertEqual("LD (HL), 0xFA", instruction.description, "wrong description")
    
    instruction.execute(ctx)
    
    let dataAtMemoryLocation = ctx.memoryAccess.readUInt8(0x1000)
    
    XCTAssertEqual({ 250 }(), dataAtMemoryLocation, "could not load value to register")
  }
  
}
