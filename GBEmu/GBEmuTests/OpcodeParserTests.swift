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
    0xe2, 0xea, 0xf2, 0xf8, 0xf9, 0xfa,
    0xe0, 0xf0]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is LD, "Opcode \(opcode) should be a LD instruction")
    }
  }
  
  func testLdIncDecParsing() {
    
    let opcodes : [UInt8] = [ 0x22, 0x32, 0x2a, 0x3a ]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is LDIncDec, "Opcode \(opcode) should be a LD instruction")
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
      0x09, 0x19, 0x29, 0x39,
      0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
      0xc6, 0xe8]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is ADD, "Opcode \(opcode) should be an ADD instruction")
    }
  }
  
  func testSubParsing() {
    
    let opcodes : [UInt8] = [0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0xd6]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is SUB, "Opcode \(opcode) should be a SUB instruction")
    }
  }
  
  func testAndParsing() {
    
    let opcodes : [UInt8] = [0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xe6]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is AND, "Opcode \(opcode) should be an AND instruction")
    }
  }
  
  func testOrParsing() {
    
    let opcodes : [UInt8] = [0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xf6]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is OR, "Opcode \(opcode) should be an OR instruction")
    }
  }
  
  func testADCParsing() {
    
    let opcodes : [UInt8] = [0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xce]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is ADC, "Opcode \(opcode) should be an ADC instruction")
    }
  }
  
  func testSBCParsing() {
    
    let opcodes : [UInt8] = [0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f, 0xde]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is SBC, "Opcode \(opcode) should be a SBC instruction")
    }
  }
  
  func testXORParsing() {
    
    let opcodes : [UInt8] = [0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf, 0xee]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is XOR, "Opcode \(opcode) should be a XOR instruction")
    }
  }
  
  func testCPParsing() {
    
    let opcodes : [UInt8] = [0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0xfe]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is CP, "Opcode \(opcode) should be a CP instruction")
    }
  }
  
  func testPUSHParsing() {
    
    let opcodes : [UInt8] = [0xc5, 0xd5, 0xe5, 0xf5]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is PUSH, "Opcode \(opcode) should be a PUSH instruction")
    }
  }
  
  func testPOPParsing() {
    
    let opcodes : [UInt8] = [0xc1, 0xd1, 0xe1, 0xf1]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is POP, "Opcode \(opcode) should be a POP instruction")
    }
  }
  
  func testJPParsing() {
    
    let opcodes : [UInt8] = [0x20, 0x30, 0x18, 0x28, 0x38, 0xc2, 0xd2, 0xc3, 0xca, 0xda, 0xe9]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is JP, "Opcode \(opcode) should be a JP instruction")
    }
  }
  
  func testRSTParsing() {
    
    let opcodes : [UInt8] = [0xC7, 0xD7, 0xE7, 0xF7, 0xCF, 0xDF, 0xEF, 0xFF]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is RST, "Opcode \(opcode) should be a RST instruction")
    }
  }
  
  func testCALLParsing() {
    
    let opcodes : [UInt8] = [0xC4, 0xD4, 0xCC, 0xDC, 0xCD]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is CALL, "Opcode \(opcode) should be a RST instruction")
    }
  }
  
  func testRETParsing() {
    
    let opcodes : [UInt8] = [0xc0, 0xd0, 0xc8, 0xd8, 0xc9, 0xd9]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is RET, "Opcode \(opcode) should be a RST instruction")
    }
  }
  
  func testRotateParsing() {
    
    let opcodes : [UInt8] = [0x07, 0x17, 0x0f, 0x1f]
    
    let parser = OpcodeParser()
    
    for code in opcodes {
      let instruction = parser.parseInstruction(code, fetchNextBytePredicate: { return UInt8(0)})
      
      let opcode = NSString(format: "%2X", code)
      XCTAssert(instruction is RotateInstruction, "Opcode \(opcode) should be a RST instruction")
    }
  }
  
  func testMISCParsing() {
    
    let parser = OpcodeParser()
    var instruction = parser.parseInstruction(0xF3, fetchNextBytePredicate: { return UInt8(0)})
    var opcode = NSString(format: "%2X", 0xF3)
    XCTAssert(instruction is DI, "Opcode \(opcode) should be a DI instruction")
    
    instruction = parser.parseInstruction(0xFB, fetchNextBytePredicate: { return UInt8(0)})
    opcode = NSString(format: "%2X", 0xFB)
    XCTAssert(instruction is EI, "Opcode \(opcode) should be an EI instruction")
  }
}
