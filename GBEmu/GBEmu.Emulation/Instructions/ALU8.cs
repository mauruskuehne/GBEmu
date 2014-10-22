using System;

namespace GBEmu.Emulation
{
	public static class ALU8
	{
		public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
		{
			UInt16 valU16 = 0;
			byte valU8 = 0;
			var res = new InstructionParseResult ();
			res.ClockCycles = 0;

			switch (opcode) {
			case 0x01: //LD BC, nn
				registers.BC = memoryAccess.ReadUInt16AtAddress (registers.GetPC (2), true);
				res.ClockCycles = 12;
				break;
			}

			return res.ClockCycles > 0 ? res : null;
		}
	}
}

