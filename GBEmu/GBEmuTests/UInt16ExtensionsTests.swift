//
//  UInt16ExtensionsTests.swift
//  GBEmu
//
//  Created by Maurus Kühne on 13.11.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa
import XCTest
import GBEmu

class UInt16ExtensionsTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testBytesToUInt16() {
    let byte1 : Byte = 0xFF;
    let byte2 : Byte = 0x00;
    
    let val255 = UInt16.fromUpperByte(byte2, lowerByte: byte1)
    
    XCTAssertEqual(val255, {0x00FF}(), "UInt16 was not created correctly")
    
    let val65280 = UInt16.fromUpperByte(byte1, lowerByte: byte2)
    
    XCTAssertEqual(val65280, {0xFF00}(), "UInt16 was not created correctly")
  }
  
  func testUInt16ToBytes() {
    let twoByteValue : UInt16 = 0xFF00
    
    let bytes = twoByteValue.toBytes()
    
    XCTAssertEqual(bytes.lower, {0x00}(), "could not extract lower byte from UInt16")
    XCTAssertEqual(bytes.upper, {0xFF}(), "could not extract upper byte from UInt16")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
      // Put the code you want to measure the time of here.
    }
  }
  
}
