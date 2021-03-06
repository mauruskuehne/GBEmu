//
//  Display.swift
//  GBEmu
//
//  Created by Maurus Kühne on 14.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

class Display {
  var isDisplayOperating = false
  var isWindowDisplayOn = false
  var isBgAndWindowDisplayOn = false
  
  let tileMapSize : UInt16 = 0x3FF
  
  //Window Tile Map Display Select
  var Window_Tile_Map_Display_Select : UInt16 = 0
  
  //BG & Window Tile Data Select
  let tileDataSize : UInt16 = 0xFFF
  var BG_Window_Tile_Data_Select : UInt16 = 0
  var BG_Window_Tile_Map_Display_Select : UInt16 = 0
  
  // OBJ / Sprite
  var spriteSize : UInt8 = 0
  var isSpriteDisplayOn = false
  
  let memory : MemoryAccessor
  let executionContext : ExecutionContext
  
  var Window_Tile_Map_Display_Select_Range : [UInt8] {
    get {
      return memory.getRange(Window_Tile_Map_Display_Select, length: tileMapSize)
    }
  }
  
  var BG_Window_Tile_Data_Select_Range : [UInt8] {
    get {
      return memory.getRange(BG_Window_Tile_Data_Select, length: tileDataSize)
    }
  }
  
  var BG_Window_Tile_Map_Display_Select_Range : [UInt8] {
    get {
      return memory.getRange(BG_Window_Tile_Map_Display_Select, length: tileMapSize)
    }
  }
  
  var BG_Window_Palette_Data : UInt8 {
    get {
      return memory.readUInt8(IORegister.BGP.rawValue)
    }
  }
  
  init(context : ExecutionContext) {
    self.memory = context.memoryAccess
    self.executionContext = context
  }
  
  func initialize() {
    //Set LCLDC to 0x
    memory[IORegister.LCDC.rawValue] = 0x91
    
    configureFromLCDC()
  }
  
  func refresh() {
    
    //react to LCDC
    configureFromLCDC()
    
    //update data
    var ly = memory[IORegister.LY.rawValue]
    
    let usedCycles = executionContext.usedClockCyclesInCurrentFrame
    let cyclesPerFrame = executionContext.CYCLES_PER_FRAME
    
    let factor = Double(usedCycles) / Double(cyclesPerFrame)
    
    ly = UInt8(153.0 * factor)
    
    memory[IORegister.LY.rawValue] = ly
    
    if ly == 145 {
      memory[IORegister.IF.rawValue] |= InterruptFlag.VBlank.rawValue
    }
  }
  
  private func configureFromLCDC() {
    let lcdc = memory[IORegister.LCDC.rawValue]
    
    if isDisplayOperating && !(lcdc & LCDC.LCD_Control_Operation.rawValue > 0) {
      print("about to shut down display!")
    } else if !isDisplayOperating && !(lcdc & LCDC.LCD_Control_Operation.rawValue == 0) {
      print("about to power on display!")
    }
    isDisplayOperating = lcdc & LCDC.LCD_Control_Operation.rawValue > 0
    
    if lcdc & LCDC.Window_Tile_Map_Display_Select.rawValue > 0 {
      Window_Tile_Map_Display_Select = 0x9C00
    } else {
      Window_Tile_Map_Display_Select = 0x9800
    }
    
    isWindowDisplayOn = lcdc & LCDC.Window_Display.rawValue > 0
    
    if lcdc & LCDC.BG_Window_Tile_Data_Select.rawValue > 0 {
      BG_Window_Tile_Data_Select = 0x8000
    } else {
      BG_Window_Tile_Data_Select = 0x8800
    }
    
    if lcdc & LCDC.BG_Window_Tile_Map_Display_Select.rawValue > 0 {
      BG_Window_Tile_Map_Display_Select = 0x9C00
    } else {
      BG_Window_Tile_Map_Display_Select = 0x9800
    }
    
    if lcdc & LCDC.OBJ_Sprite_Size.rawValue > 0 { // width * height
      spriteSize = 8 * 16
    } else {
      spriteSize = 8 * 8
    }
    
    isSpriteDisplayOn = lcdc & LCDC.OBJ_Sprite_Display.rawValue > 0
    
    isBgAndWindowDisplayOn = lcdc & LCDC.BG_Window_Display.rawValue > 0
  }
}

