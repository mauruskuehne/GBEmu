//
//  LCDC.swift
//  GBEmu
//
//  Created by Maurus Kühne on 21.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

enum LCDC : UInt8 {
  case LCD_Control_Operation =              0b1000_0000
  case Window_Tile_Map_Display_Select =     0b0100_0000
  case Window_Display =                     0b0010_0000
  case BG_Window_Tile_Data_Select =         0b0001_0000
  case BG_Window_Tile_Map_Display_Select =  0b0000_1000
  case OBJ_Sprite_Size =                    0b0000_0100
  case OBJ_Sprite_Display =                 0b0000_0010
  case BG_Window_Display =                  0b0000_0001
}