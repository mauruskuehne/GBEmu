using System;

namespace GBEmu.Emulation
{
	public static class LD16
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
			case 0x11: //LD DE, nn
				registers.DE = memoryAccess.ReadUInt16AtAddress (registers.GetPC (2), true);
				res.ClockCycles = 12;
				break;
			case 0x21: //LD HL, nn
				registers.HL = memoryAccess.ReadUInt16AtAddress (registers.GetPC (2), true);
				res.ClockCycles = 12;
				break;
			case 0x31: //LD SP, nn
				registers.SP = memoryAccess.ReadUInt16AtAddress (registers.GetPC (2), true);
				res.ClockCycles = 12;
				break;
			case 0xF9: //LD SP, HL
				registers.SP = memoryAccess.ReadUInt16AtAddress (registers.HL, true);
				res.ClockCycles = 8;
				break;
			case 0xF8: //LD HL,SP+n
				var val = (sbyte)memoryAccess.ReadByteAtAddress (registers.GetPC ());

				registers.HL = (UInt16)(registers.SP + val);

				registers.SetFlagForSignedOperation (Operation.Addition, registers.SP, val);

				registers.ResetFlags (Flags.N | Flags.Z);

				res.ClockCycles = 12;
				break;
			case 0x08: //LD (nn), SP
				valU16 = memoryAccess.ReadUInt16AtAddress (registers.GetPC (2), false);
				memoryAccess.WriteAtAddress (valU16, registers.SP);
				res.ClockCycles = 20;
				break;

				//PUSH
			case 0xF5:
				registers.SP -= 2;
				memoryAccess.WriteAtAddress (registers.SP, registers.AF);
				res.ClockCycles = 16;
				break;
			case 0xC5:
				registers.SP -= 2;
				memoryAccess.WriteAtAddress (registers.SP, registers.BC);
				res.ClockCycles = 16;
				break;
			case 0xD5:
				registers.SP -= 2;
				memoryAccess.WriteAtAddress (registers.SP, registers.DE);
				res.ClockCycles = 16;
				break;
			case 0xE5:
				registers.SP -= 2;
				memoryAccess.WriteAtAddress (registers.SP, registers.HL);
				res.ClockCycles = 16;
				break;

				//POP
			case 0xF1: 
				valU16 = memoryAccess.ReadUInt16AtAddress (registers.SP);
				registers.AF = valU16;
				registers.SP += 2;
				res.ClockCycles = 12;
				break;
			case 0xC1: 
				valU16 = memoryAccess.ReadUInt16AtAddress (registers.SP);
				registers.BC = valU16;
				registers.SP += 2;
				res.ClockCycles = 12;
				break;
			case 0xD1: 
				valU16 = memoryAccess.ReadUInt16AtAddress (registers.SP);
				registers.DE = valU16;
				registers.SP += 2;
				res.ClockCycles = 12;
				break;
			case 0xE1: 
				valU16 = memoryAccess.ReadUInt16AtAddress (registers.SP);
				registers.HL = valU16;
				registers.SP += 2;
				res.ClockCycles = 12;
				break;
			}

			return res.ClockCycles > 0 ? res : null;
		}
	}
}

