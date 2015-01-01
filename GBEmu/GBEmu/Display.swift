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
  
  init(memory : MemoryAccessor) {
    self.memory = memory
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
    ly += 1
    if ly > 153 {
      ly = 0
    }
    
    memory[IORegister.LY.rawValue] = ly
    
    if ly == 145 {
      println("in vsync")
      memory[IORegister.IF.rawValue] |= InterruptFlag.VBlank.rawValue
    }
  }
  
  private func configureFromLCDC() {
    let lcdc = memory[IORegister.LCDC.rawValue]
    
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

