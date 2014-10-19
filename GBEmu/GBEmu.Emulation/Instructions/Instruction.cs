using System;
using System.Collections.Generic;

namespace GBEmu.Emulation
{
	public abstract class Instruction
	{
		public abstract int CpuCycles {
			get;
		}

		public abstract void Execute(MemoryAccess memory, Registers registers);

	}

}

