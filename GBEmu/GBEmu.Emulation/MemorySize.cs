using System;

namespace GBEmu.Emulation
{
	public class MemorySize
	{
		private const int BitsPerBank = 128 * 1024;

		private int? _overridenSizeInBits;

		public MemorySize(int nrOfBanks)
		{
			NumberOfBanks = nrOfBanks;
		}

		public MemorySize(int nrOfBanks, int sizeInBits)
		{
			NumberOfBanks = nrOfBanks;
			_overridenSizeInBits = sizeInBits;
		}

		public int NumberOfBanks {
			get;
			private set;
		}

		public int SizeInBits {
			get
			{
				return _overridenSizeInBits ?? (BitsPerBank * NumberOfBanks);
			}
		}

		public int SizeInBytes {
			get
			{
				return SizeInBits / 8;
			}
		}
	}

}

