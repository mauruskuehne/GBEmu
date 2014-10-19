using System;

namespace GBEmu.Emulation
{
	public class CPU
	{
		MemoryAccess _memoryAccess;

		public CPU (MemoryAccess _memoryAccess)
		{
			this._memoryAccess = _memoryAccess;
		}

		public void Reset ()
		{
		}
	}
}

