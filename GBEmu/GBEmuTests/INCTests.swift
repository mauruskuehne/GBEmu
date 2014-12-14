//
//  INCTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 20.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class INCTests: XCTestCase {
  
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
  
  func test8BitIncrease() {
    
    ctx.registers.A = 0x10
    
    let register = RegisterDataLocation(register: Register.A)
    
    let instruction = INC(locToIncrease: register)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.A, UInt8(0x11), "could not increase register value")
  }
  
  func testMemoryIncrease() {
    
    let address : UInt16 = 0x1000
    
    ctx.memoryAccess.write(address, value: UInt8(0x20))
    
    let memoryLocation = MemoryDataLocation(address: address, size: DataSize.UInt8)
    
    let instruction = INC(locToIncrease: memoryLocation)
    
    instruction.execute(ctx)
    
    let newValue = ctx.memoryAccess.readUInt8(address)
    
    XCTAssertEqual(newValue, UInt8(0x21), "could not increase value in memory")
    
  }
  
  func test16BitIncrease() {
    ctx.registers.HL = 0x200
    
    let register = RegisterDataLocation(register: Register.HL)
    
    let instruction = INC(locToIncrease: register)
    
    instruction.execute(ctx)
    
    XCTAssertEqual(ctx.registers.HL, UInt16(0x201), "could not increase register value")
  }
  
  
}
