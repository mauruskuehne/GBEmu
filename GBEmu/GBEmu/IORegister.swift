//
//  IORegisters.swift
//  GBEmu
//
//  Created by Maurus Kühne on 14.12.14.
//  Copyright (c) 2014 Maurus Kühne. All rights reserved.
//

import Foundation

enum IORegister : UInt16 {
  case P1     = 0xFF00 // joy pad info (r/w)
  case SB     = 0xFF01 // serial transfer data (r/w)
  case SC     = 0xFF02 // SIO control (r/w)
  case DIV    = 0xFF04 // Divider Register (r/w)
  case TIMA   = 0xFF05 // Timer counter (r/w)
  case TMA    = 0xFF06 // Timer Modulo (r/w)
  case TAC    = 0xFF07 // Timer Control (r/w)
  case IF     = 0xFF0F // Interrupt Flag (r/w)
  
  case NR_10  = 0xFF10 // Sound Mode 1 register / Sweep Register (r/w)
  case NR_11  = 0xFF11 // Sound Mode 1 Register / Sound length / wave pattern duty (r/w)
  case NR_12  = 0xFF12 // Sound Mode 1 Register / Envelope (r/w)
  case NR_13  = 0xFF13 // Sound Mode 1 Register / Frequency lo (w)
  case NR_14  = 0xFF14 // Sound Mode 1 Register / Frequency hi (r/w)
  
  case NR_21  = 0xFF16 // Sound Mode 2 Register / Sound length / wave pattern duty (r/w)
  case NR_22  = 0xFF17 // Sound Mode 2 Register / Envelope (r/w)
  case NR_23  = 0xFF18 // Sound Mode 2 Register / Frequency lo (w)
  case NR_24  = 0xFF19 // Sound Mode 2 Register / Frequency hi (r/w)
  
  case NR_30  = 0xFF1A // Sound Mode 3 Register / Sound on/off (r/w)
  case NR_31  = 0xFF1B // Sound Mode 3 Register / Sound length (r/w)
  case NR_32  = 0xFF1C // Sound Mode 3 Register / select output length (r/w)
  case NR_33  = 0xFF1D // Sound Mode 3 Register / Frequency lo (r/w)
  case NR_34  = 0xFF1E // Sound Mode 3 Register / Frequency hi (r/w)
  
  case NR_41  = 0xFF20 // Sound Mode 4 Register / Sound length (r/w)
  case NR_42  = 0xFF21 // Sound Mode 4 Register / Envelope (r/w)
  case NR_43  = 0xFF22 // Sound Mode 4 Register / polynomial counter (r/w)
  case NR_44  = 0xFF23 // Sound Mode 4 Register / counter / consecutive; initial (r/w)
  
  case NR_50  = 0xFF24 // channel control / on-off / volume (r/w)
  case NR_51  = 0xFF25 // selection of sound output terminal (r/w)
  case NR_52  = 0xFF26 // sound on-off (r/w)
  
  case WAVE_RAM = 0xFF30 // wave pattern RAM (0xff30 / 0xff3f
  
  case LCDC   = 0xFF40 // lcd control (r/w)
  case STAT   = 0xFF41 // lcdc status (r/w)
  case SCY    = 0xFF42 // scroll y (r/w)
  case SCX    = 0xFF43 // scroll x (r/w)
  case LY     = 0xFF44 // lcdc y-coordinate (r)
  case LYC    = 0xFF45 // LY compare (r/w)
  
  case DMA    = 0xFF46 // DMA transfer and Start address (w)
  case BGP    = 0xFF47 // BG & Window Palette Data (r/w)
  
  case OBP0   = 0xFF48 // object palette 0 data (r/w)
  case OBP1   = 0xFF49 // object Palette 1 data (r/w)
  
  case WY     = 0xFF4A // window y position (r/w)
  case WX     = 0xFF4B // window x position (r/w)
  
  case IE     = 0xFFFF // interrupt enable
  
  static let allValues = [P1, SB, SC, DIV, TIMA, TMA, TAC, IF, NR_10, NR_11, NR_12, NR_13, NR_14, NR_21, NR_22, NR_23, NR_24, NR_30, NR_31, NR_32, NR_33, NR_34, NR_41, NR_42, NR_43, NR_44,
  NR_50, NR_51, NR_52, WAVE_RAM, LCDC, STAT, SCY, SCX, LY, LYC, DMA, BGP, OBP0, OBP1, WY, WX, IE]
}