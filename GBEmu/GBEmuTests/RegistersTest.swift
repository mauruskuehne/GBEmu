//
//  RegistersTest.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest
import GBEmu

class RegistersTest: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testRegisters() {
    let registers = Registers()
    
    registers.A = 0xFF
    registers.Flags = 0x00
    
    XCTAssertEqual(registers.AF, { 0xFF00 }(), "Register AF does not correspond to Registers A and F")
    
    registers.AF = 0x00FF
    
    XCTAssertEqual(registers.A, { 0x00 }(), "Register AF does not correspond to Registers A and F")
    XCTAssertEqual(registers.Flags, { 0xFF }(), "Register AF does not correspond to Registers A and F")
    
    registers.B = 0xFF
    registers.C = 0x00
      
    XCTAssertEqual(registers.BC, { 0xFF00 }(), "Register AF does not correspond to Registers A and F")
      
    registers.BC = 0x00FF
      
    XCTAssertEqual(registers.B, { 0x00 }(), "Register AF does not correspond to Registers A and F")
    XCTAssertEqual(registers.C, { 0xFF }(), "Register AF does not correspond to Registers A and F")
    
    registers.D = 0xFF
    registers.E = 0x00
    
    XCTAssertEqual(registers.DE, { 0xFF00 }(), "Register AF does not correspond to Registers A and F")
    
    registers.DE = 0x00FF
      
    XCTAssertEqual(registers.D, { 0x00 }(), "Register AF does not correspond to Registers A and F")
    XCTAssertEqual(registers.E, { 0xFF }(), "Register AF does not correspond to Registers A and F")
    
    
    registers.H = 0xFF
    registers.L = 0x00
    
    XCTAssertEqual(registers.HL, { 0xFF00 }(), "Register AF does not correspond to Registers A and F")
    
    registers.HL = 0x00FF
    
    XCTAssertEqual(registers.H, { 0x00 }(), "Register AF does not correspond to Registers A and F")
    XCTAssertEqual(registers.L, { 0xFF }(), "Register AF does not correspond to Registers A and F")
  }
  
}
