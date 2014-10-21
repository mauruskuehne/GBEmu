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

    public static UInt16 UInt16FromBytes(byte lsb, byte msb)
    {
      UInt16 val = ((UInt16) (msb << 8));
      val = (UInt16)(val & lsb);
      return val;
    }

   }
}

