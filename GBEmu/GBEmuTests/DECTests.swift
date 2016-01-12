//
//  INCTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 20.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class DECTests: XCTestCase {
  
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
  
  func test8BitDecrease() {
    
    ctx.registers.A = 0xA
    
    let register = RegisterDataLocation(register: Register.A)
    
    let instruction = DEC(opcode: 0, locToDecrease: register)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0x09), "could not decrease register value")
  }
  
  func testMemoryDecrease() {
    
    let address : UInt16 = 0x1000
    
    ctx.memoryAccess.write(address, value: UInt8(0x21))
    
    let memoryLocation = MemoryDataLocation(address: address, size: DataSize.UInt8)
    
    let instruction = DEC(opcode: 0, locToDecrease: memoryLocation)
    
    instruction.execute(ctx)
    
    let newValue = ctx.memoryAccess.readUInt8(address)
    
    XCTAssertEqual(newValue, UInt8(0x20), "could not decrease value in memory")
    
  }
  
  func test16BitDecrease() {
    ctx.registers.HL = 0x201
    
    let register = RegisterDataLocation(register: Register.HL)
    
    let instruction = DEC(opcode: 0, locToDecrease: register)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.HL, UInt16(0x200), "could not decrease register value")
  }
  
  
}
