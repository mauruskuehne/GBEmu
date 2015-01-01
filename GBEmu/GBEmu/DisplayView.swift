//
//  DisplayView.swift
//  GBEmu
//
//  Created by Maurus Kühne on 19.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Cocoa

class DisplayView : NSView {
  
  let engine = EmulationEngineContainer.sharedEngine
  let display = EmulationEngineContainer.sharedEngine.display
  
  let DARK_COLOR = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
  let LIGHT_COLOR = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
  let MID_DARK_COLOR = NSColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1)
  let MID_LIGHT_COLOR = NSColor(red: 0.66, green: 0.66, blue: 0.66, alpha: 1)
  
  func refresh() {
    needsDisplay = true
  }
  
  func getColorForDotData(data : UInt8) -> NSColor {
    
    var bitMask : UInt8 = 0
    var shiftVal : UInt8 = 0
    switch(data) {
    case 0b11 :
      bitMask = 0b11000000
      shiftVal = 6
    case 0b10 :
      bitMask = 0b00110000
      shiftVal = 4
    case 0b01 :
      bitMask = 0b00001100
      shiftVal = 2
    case 0b00 :
      bitMask = 0b00000011
      shiftVal = 0
    default :
      assertionFailure("no color data available ")
    }
    
    var intensity = (display.BG_Window_Palette_Data & bitMask) >> shiftVal
    var col : NSColor
    switch(intensity) {
    case 0 :
      col = DARK_COLOR
    case 1 :
      col = MID_DARK_COLOR
    case 2 :
      col = MID_LIGHT_COLOR
    case 3 :
      col = LIGHT_COLOR
    default:
      assertionFailure("this color is not supported")
    }
    
    return col
  }
  
  override func drawRect(dirtyRect: NSRect) {
    
    let ctx = NSGraphicsContext.currentContext()!
    
    NSColor.blackColor().set()
    NSRectFill(dirtyRect)
    
    if !display.isDisplayOperating {
      return
    }
    
    if display.isBgAndWindowDisplayOn {
      drawBackground(dirtyRect)
    }
    
  }
  
  func drawBackground(dirtyRect : NSRect) {
    
    //WARNING: this only works for data table located at 0x8000.
    // data table at 0x8800 uses a signed index, which this function can't handle yet
    
    let tileData = display.BG_Window_Tile_Data_Select_Range
    let tileMap = display.BG_Window_Tile_Map_Display_Select_Range
    var ctx = 0
    let splitTileMap = split(tileMap, { (c:UInt8)->Bool in (ctx++ % 32) == 0 && ctx != 0 }, allowEmptySlices: true)
    
    var rowIndex = 0
    for tileRow in splitTileMap {
      var colIndex = 0
      for tile in tileRow {
        
        //1 tile consists of 8 bytes
        
        let tileStart = Int(tile) * 16
        
        let singleTileData = tileData[tileStart..<(tileStart + 16)]
        //self.memory[Int(address)...Int(address + length)]
        drawTileData(Array(singleTileData), tilePositionX: colIndex, tilePositionY: rowIndex)
        
        colIndex++
      }
      rowIndex++
    }
  }
  
  func drawTileData(data : [UInt8], tilePositionX : Int, tilePositionY : Int) {
    
    let xPixelStart = 8 * tilePositionX
    let yPixelStart = 8 * tilePositionY
    
    for line in 0..<8 {
      let firstLineBit = data[line * 2] //LSB
      let secondLineBit = data[(line * 2) + 1] // MSB
      
      
      for pixel : UInt8 in 0..<8 {
        
        let mask : UInt8 = 0b1 << (7 - pixel)
        let firstBit = (firstLineBit & mask) >> (7 - pixel)
        
        let secondBit = ((secondLineBit & mask) >> (7 - pixel)) << 1 //MSB um eins weniger shiften, damit es an 2. Stelle bleibt
        
        let colorData : UInt8 = 0 | firstBit | secondBit
        let color = getColorForDotData(colorData)
        /*
        let mask : UInt16 = 0b11 << (14 - (pixel * 2))
        let colorData = UInt8((lineData & mask) >> UInt16(pixel * 2))
        let color = getColorForDotData(colorData)*/
       
        let xPixelPos = xPixelStart + Int(pixel)
        let yPixelPos = yPixelStart + (7 - line) // 0,0 ist in Cocoa oben links, deshalb muss y-Achse gedreht werden
        let point = CGPoint(x: xPixelPos, y: yPixelPos)
        
        color.set()
        let pixel = NSRect(origin: point, size: CGSize(width: 1, height: 1))
        NSRectFill(pixel)
        //NSBezierPath.strokeLineFromPoint(point, toPoint: point)
        
      }
      
    }
  }
}