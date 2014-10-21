using System;

namespace GBEmu.Emulation
{
	public class MemoryAccess
	{
		ROM _rom;

    byte[] _memory;

		public MemoryAccess ()
		{
      _memory = new byte[0xFFFF];
		}

		public void InitializeWithRom (ROM rom)
		{
			_rom = rom; 

      var bank0 = _rom.RawData.GetSubArray(0, 16 * 1024);

      bank0.CopyTo(_memory, 0);
		}

		public byte ReadByteAtAddress(UInt16 address)
		{
      return _memory[address];
		}

    public UInt16 ReadUInt16AtAddress(UInt16 address, bool lsbFirst)
    {
      var b1 = _memory[address];
      var b2 = _memory[address + 1];

      if (lsbFirst)
        return IntegerExtensions.UInt16FromBytes(b1, b2);
      else
        return IntegerExtensions.UInt16FromBytes(b2, b1);
    }

    public void WriteAtAddress(UInt16 address, byte value)
    {
      _memory[address] = value;
    }

		public byte[] ReadByteAtAddress(int address, int length)
		{
			/*
			 * FFFF - Interrupt Enable Register
			 * FF80 - Internal RAM 
			 * FF4C - Empty but unusable for I/O
			 * FF00 - I/O ports 
			 * FEA0 - Empty but unusable for I/O 
			 * FE00 - Sprite Attrib Memory (OAM) 
			 * E000 - Echo of 8kB Internal RAM
			 * C000 - 8kB Internal RAM 
			 * A000 - 8kB switchable RAM bank 
			 * 8000 - 8kB Video RAM 
			 * 4000 - 16kB switchable ROM bank
			 * 0000 - 16kB ROM bank #0
			 * 
			 * read like this: ROM bank #0 goes from 0000 to 4000, switchable rom bank goes from 4000 to 8000, and so on...
			*/

      return _memory.GetSubArray(address, length);
		}
	}
}

