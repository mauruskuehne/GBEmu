using System;

namespace GBEmu.Emulation
{
	public static class IntegerExtensions
	{
		public static byte GetUpperByte(this UInt16 val)
		{
			return ((byte) (val >> 8));
		}

		public static byte GetLowerByte(this UInt16 val)
		{
			return ((byte) (val & 0x0F));
		}
	}
}

