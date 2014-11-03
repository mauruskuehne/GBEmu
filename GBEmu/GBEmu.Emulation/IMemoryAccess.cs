using System;

namespace GBEmu.Emulation
{
	public interface IMemoryAccess
	{
		void WriteAtAddress(UInt16 address, byte value);
		void WriteAtAddress(UInt16 address, UInt16 value);
		void WriteAtAddress(UInt16 address, byte[] bytes);

		byte ReadByteAtAddress (UInt16 address);
		UInt16 ReadUInt16AtAddress (UInt16 address, bool lsbFirst = false);
	}
}

