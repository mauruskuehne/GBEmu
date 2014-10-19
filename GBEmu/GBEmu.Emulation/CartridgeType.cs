using System;

namespace GBEmu.Emulation
{
	public enum CartridgeType : byte
	{
		ROM_ONLY = 0,
		ROM_MBC1 = 0x1,
		ROM_MBC1_RAM = 0x2,
		ROM_MBC1_RAM_BATT  = 0x3,
		ROM_MBC2 = 0x5,
		ROM_MBC2_BATTERY = 0x6,
		ROM_RAM = 0x7,
		ROM_RAM_BATTERY = 0x8,
		ROM_MMM01 = 0x9,
		ROM_MMM01_SRAM = 0xB,
		ROM_MMM01_SRAM_BATT = 0xC,
		ROM_MBC3_RAM = 0xD,
		ROM_MBC3_RAM_BATT = 0x12,
		ROM_MBC5 = 0x13,
		ROM_MBC5_RAM = 0x19,
		ROM_MBC5_RAM_BATT = 0x1A,
		ROM_MBC5_RUMBLE = 0x1C,
		ROM_MBC5_RUMBLE_SRAM = 0x1D,
		ROM_MBC5_RUMBLE_SRAM_BATT = 0x1E,
		Pocket_Camera = 0x1F,
		Bandai_TAMA5 = 0xFD, 
		Hudson_HuC3 = 0xFE,
		ROM_MBC3_TIMER_BATT = 0xF,
		Hudson_HuC1 = 0xFF,
		ROM_MBC3_TIMER_RAM_BATT = 0x10,
		ROM_MBC3 = 0x11
	}

}

