using System;

namespace GBEmu.Emulation
{
	public class Bit
	{
		public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
		{
			UInt16 valU16 = 0;
			byte valU8 = 0;
			var res = new InstructionParseResult ();
			res.ClockCycles = 0;

			switch (opcode) {
			//ADD A,n
			case 0x87: 
				break;

			default:
				break;
			}

			return res.ClockCycles > 0 ? res : null;
		}
	}
}

