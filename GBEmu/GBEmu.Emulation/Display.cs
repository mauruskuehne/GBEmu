using System;

namespace GBEmu.Emulation
{
	public class Display
	{
		MemoryAccess _memoryAccess;

		public Display (MemoryAccess _memoryAccess)
		{
			this._memoryAccess = _memoryAccess;
		}

		public void Reset ()
		{
		}
	}
}

