using System;

namespace GBEmu.Emulation
{
	public class MemoryAccess
	{
		ROM _rom;

		public MemoryAccess ()
		{
		}

		public void InitializeWithRom (ROM rom)
		{
			_rom = rom; 
		}

		public byte ReadAtAddress(int address)
		{
			throw new NotImplementedException ();
		}

		public byte[] ReadAtAddress(int address, int length)
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

			throw new NotImplementedException ();
		}
	}
}

