//
//  OpcodeParserTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 24.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest

class OpcodeParserTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testLdParsing() {
    
    let opcodes : [UInt8] = [ 0x01, 0x02, 0x06, 0x08, 0x0A, 0x0E,
    0x11, 0x12, 0x16, 0x1A, 0x1E,
    0x21, 0x26, 0x2E,
    0x31, 0x36, 0x3E,
    0x40, 0x41, 0x42,0x43,0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f,
    0x50, 0x51, 0x52,0x53,0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f,
    0x60, 0x61, 0x62,0x63,0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f,
    0x70, 0x71, 0x72,0x73,0x74, 0x75, /*0x76=HALT */0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f,
    0xe2, 0xea, 0xf2, 0xf9, 0xfa]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is LD, "Opcode \(opcode) should be a LD instruction")
    }
  }
  
  func testIncParsing() {
    
    let opcodes : [UInt8] = [
      0x03, 0x04, 0x0c,
      0x13, 0x14, 0x1c,
      0x23, 0x24, 0x2c,
      0x33, 0x34, 0x3c]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is INC, "Opcode \(opcode) should be an INC instruction")
    }
  }
  
  func testDecParsing() {
    
    let opcodes : [UInt8] = [
      0x05, 0x0b, 0x0d,
      0x15, 0x1b, 0x1d,
      0x25, 0x2b, 0x2d,
      0x35, 0x3b, 0x3d]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is DEC, "Opcode \(opcode) should be a DEC instruction")
    }
  }
  
  func testAddParsing() {
    
    let opcodes : [UInt8] = [
      0x09, 0x10, 0x29, 0x39,
      0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
      0xc6, 0xe8]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is ADD, "Opcode \(opcode) should be an ADD instruction")
    }
  }
  
}
