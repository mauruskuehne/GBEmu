//
//  PUSHPOPTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 26/11/14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class PUSHPOPTests: XCTestCase {
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

    func testPUSHPOP() {
      
      ctx.registers.HL = 1234
      
      let readReg = RegisterDataLocation(register: Register.HL)
      let writeReg = RegisterDataLocation(register: Register.BC)
      
      let pushInstr = PUSH(locationToWrite: readReg)
      let popInstr = POP(locationToStore: writeReg)
      
      pushInstr.execute(ctx)
      
      
      XCTAssertEqual(ctx.memoryAccess.readUInt16(ctx.registers.SP), {1234}(), "could not store value on stack")
      
    }

}
