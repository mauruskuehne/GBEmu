using System;

namespace GBEmu.Emulation
{
	public class ALU16
	{
		public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
		{
			UInt16 valU16 = 0;
			byte valU8 = 0;
			sbyte valS8 = 0;
			var res = new InstructionParseResult ();
			res.ClockCycles = 0;

			switch (opcode) {
			//ADD HL,n
			case 0x09: 
				registers.SetFlagForUInt32Operation (Operation.Addition, registers.HL, registers.BC);
				registers.HL += registers.BC;
				res.ClockCycles = 8;
				break;
			case 0x19: 
				registers.SetFlagForUInt32Operation (Operation.Addition, registers.HL, registers.BC);
				registers.HL += registers.DE;
				res.ClockCycles = 8;
				break;
			case 0x29: 
				registers.SetFlagForUInt32Operation (Operation.Addition, registers.HL, registers.BC);
				registers.HL += registers.HL;
				res.ClockCycles = 8;
				break;
			case 0x39: 
				registers.SetFlagForUInt32Operation (Operation.Addition, registers.HL, registers.BC);
				registers.HL += registers.SP;
				res.ClockCycles = 8;
				break;

				//ADD SP,n

			case 0xE8: 
				valS8 = (sbyte)memoryAccess.ReadByteAtAddress (registers.GetPC ());

				registers.SetFlagForSignedOperation (Operation.ADDSP, registers.SP, valS8);

				registers.SetFlagForUInt32Operation (Operation.Addition, registers.HL, registers.BC);
				registers.HL += registers.SP;
				res.ClockCycles = 16;
				break;

				//INC nn
			case 0x03: 
				registers.BC++;
				res.ClockCycles = 8;
				break;
			case 0x13: 
				registers.DE++;
				res.ClockCycles = 8;
				break;
			case 0x23: 
				registers.HL++;
				res.ClockCycles = 8;
				break;
			case 0x33: 
				registers.SP++;
				res.ClockCycles = 8;
				break;

				//DEC nn
			case 0x0B: 
				registers.BC--;
				res.ClockCycles = 8;
				break;
			case 0x1B: 
				registers.DE--;
				res.ClockCycles = 8;
				break;
			case 0x2B: 
				registers.HL--;
				res.ClockCycles = 8;
				break;
			case 0x3B: 
				registers.SP--;
				res.ClockCycles = 8;
				break;



			}


			return res.ClockCycles > 0 ? res : null;
		}
	}
}

