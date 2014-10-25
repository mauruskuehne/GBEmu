using System;

namespace GBEmu.Emulation
{
	public class RotateAndShift
	{
		public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
		{
			byte secondOpcode = 0;
			byte newLower = 0;
			byte newUpper = 0;
			var res = new InstructionParseResult ();
			res.ClockCycles = 0;


			switch (opcode) {

			//RLCA

			case 0x07:

				byte bit7Val = (byte)(registers.A & 0xFF);

				byte newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);

				byte newVal = (byte)((registers.A << 1) + newFirstBit);

				registers.A = newVal;

				registers.SetFlagForUnsignedByteOperation (Operation.RLCA, registers.A);

				res.ClockCycles = 4;
				break;

				//RLA

			case 0x17:

				bit7Val = (byte)(registers.A & 0xFF);

				newFirstBit = (byte)( bit7Val == 0 ? 0 : 1);
				newVal = (byte)((registers.A << 1) + registers.GetFlag(Flags.C));
				registers.A = newVal;
				registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, registers.A, newFirstBit);

				res.ClockCycles = 4;
				break;


				//RRCA

			case 0x0F:

				byte bit0Val = (byte)(registers.A & 0x01);

				byte newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);

				newVal = (byte)((registers.A >> 1) + newLastBit);

				registers.A = newVal;

				registers.SetFlagForUnsignedByteOperation (Operation.RRCA, registers.A);

				res.ClockCycles = 4;
				break;

				//RRA

			case 0x1F:

				bit0Val = (byte)(registers.A & 0x01);

				newLastBit = (byte)( bit0Val == 0 ? 0 : 1);
				newVal = (byte)((registers.A >> 1) + (registers.GetFlag(Flags.C) == 1 ? 0xFF : 0));
				registers.A = newVal;
				registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, registers.A, newLastBit);

				res.ClockCycles = 4;
				break;


				//RLC n / RL n / RRC n / RR n

			case 0xCB:

				//this is getting stupid... any way to unify this code????

				break;
			}


			return res.ClockCycles > 0 ? res : null;
		}
	}
}

