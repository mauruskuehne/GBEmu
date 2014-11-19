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
      
    XCTAssertEqual(registers.BC, { 0xFF00 }(), "Register BC does not correspond to Registers B and C")
      
    registers.BC = 0x00FF
      
    XCTAssertEqual(registers.B, { 0x00 }(), "Register BC does not correspond to Registers B and C")
    XCTAssertEqual(registers.C, { 0xFF }(), "Register BC does not correspond to Registers B and C")
    
    registers.D = 0xFF
    registers.E = 0x00
    
    XCTAssertEqual(registers.DE, { 0xFF00 }(), "Register DE does not correspond to Registers D and E")
    
    registers.DE = 0x00FF
    
    XCTAssertEqual(registers.D, { 0x00 }(), "Register DE does not correspond to Registers D and E")
    XCTAssertEqual(registers.E, { 0xFF }(), "Register DE does not correspond to Registers D and E")
    
    
    registers.H = 0xFF
    registers.L = 0x00
    
    XCTAssertEqual(registers.HL, { 0xFF00 }(), "Register HL does not correspond to Registers H and L")
    
    registers.HL = 0x00FF
    
    XCTAssertEqual(registers.H, { 0x00 }(), "Register HL does not correspond to Registers H and L")
    XCTAssertEqual(registers.L, { 0xFF }(), "Register HL does not correspond to Registers H and L")
  }
  
  func testSubscript() {
    
    let register = Registers()
    
    let smallValue : UInt8 = 255
    let overflowValue : UInt16 = 257
    let bigValue : UInt16 = 12345
    
    register[Register.A] = smallValue
    XCTAssertEqual(register.A, smallValue, "could not set \(smallValue) to register A!")
    
    register[Register.HL] = smallValue
    XCTAssertEqual(String(register.HL), String(smallValue), "could not set \(smallValue) to register HL!")
    
    
    register[Register.A] = overflowValue
    XCTAssertEqual(register.A, { 1 }(), "could not set \(overflowValue) to register A!")
    
    register[Register.HL] = overflowValue
    XCTAssertEqual(register.HL, overflowValue, "could not set \(overflowValue) to register HL!")
    
    
    register[Register.A] = bigValue
    XCTAssertEqual(String(register.A), String(bigValue % UInt8.max), "could not set value to register A!")
    
    register[Register.HL] = bigValue
    XCTAssertEqual(register.HL, bigValue, "could not set \(bigValue) to register HL!")
  }
}
