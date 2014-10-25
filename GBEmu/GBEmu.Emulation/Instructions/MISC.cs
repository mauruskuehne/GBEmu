using System;

namespace GBEmu.Emulation
{
	public static class MISC
	{
		public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
		{
			byte secondOpcode = 0;
			byte newLower = 0;
			byte newUpper = 0;
			var res = new InstructionParseResult ();
			res.ClockCycles = 0;


			switch (opcode) {

			case 0xCB:

				secondOpcode = memoryAccess.ReadByteAtAddress (registers.GetPC (peek: true));
				switch (secondOpcode) {

				//SWAP n
				case 0x37: 
					newUpper = (byte)(registers.A << 4);
					newLower = (byte)(registers.A >> 4);
					registers.A = (byte)(newUpper + newLower);
					registers.SetFlagForUnsignedByteOperation (Operation.SWAP, registers.A);
					res.ClockCycles = 8;
					break;
				case 0x30: 
					newUpper = (byte)(registers.A << 4);
					newLower = (byte)(registers.A >> 4);
					registers.B = (byte)(newUpper + newLower);
					registers.SetFlagForUnsignedByteOperation (Operation.SWAP, registers.B);
					res.ClockCycles = 8;
					break;
				case 0x31: 
					newUpper = (byte)(registers.A << 4);
					newLower = (byte)(registers.A >> 4);
					registers.C = (byte)(newUpper + newLower);
					registers.SetFlagForUnsignedByteOperation (Operation.SWAP, registers.C);
					res.ClockCycles = 8;
					break;
				case 0x32: 
					newUpper = (byte)(registers.A << 4);
					newLower = (byte)(registers.A >> 4);
					registers.D = (byte)(newUpper + newLower);
					registers.SetFlagForUnsignedByteOperation (Operation.SWAP, registers.D);
					res.ClockCycles = 8;
					break;
				case 0x33: 
					newUpper = (byte)(registers.A << 4);
					newLower = (byte)(registers.A >> 4);
					registers.E = (byte)(newUpper + newLower);
					registers.SetFlagForUnsignedByteOperation (Operation.SWAP, registers.E);
					res.ClockCycles = 8;
					break;
				case 0x34: 
					newUpper = (byte)(registers.A << 4);
					newLower = (byte)(registers.A >> 4);
					registers.H = (byte)(newUpper + newLower);
					registers.SetFlagForUnsignedByteOperation (Operation.SWAP, registers.H);
					res.ClockCycles = 8;
					break;
				case 0x35: 
					newUpper = (byte)(registers.A << 4);
					newLower = (byte)(registers.A >> 4);
					registers.L = (byte)(newUpper + newLower);
					registers.SetFlagForUnsignedByteOperation (Operation.SWAP, registers.L);
					res.ClockCycles = 8;
					break;
				case 0x36: 
					var val = memoryAccess.ReadByteAtAddress (registers.HL);
					newUpper = (byte)(val << 4);
					newLower = (byte)(val >> 4);
					registers.SetFlagForUnsignedByteOperation (Operation.SWAP, (byte)(newUpper + newLower));
					memoryAccess.WriteAtAddress (registers.HL, (byte)(newUpper + newLower));
					res.ClockCycles = 16;
					break;


				}

				// if we found a match, we remove the peeked value from PC
				if (res.ClockCycles > 0)
					registers.GetPC ();

				break;

				// DAA
			case 0x27:
				//see http://www.z80.info/z80code.htm

				throw new NotImplementedException ("maybe later..");
				break;


				//CPL

			case 0x2F:

				registers.A = (byte) ~registers.A;
				registers.SetFlagForUnsignedByteOperation (Operation.CPL, registers.A);
				res.ClockCycles = 4;
				break;

				//CCF

			case 0x3F:

				registers.SetFlagForUnsignedByteOperation (Operation.CCF);
				res.ClockCycles = 4;
				break;

				//SCF

			case 0x37:

				registers.SetFlagForUnsignedByteOperation (Operation.SCF);
				res.ClockCycles = 4;
				break;

				//NOP

			case 0x00:

				res.ClockCycles = 4;
				break;

				//HALT
			case 0x76:
				res.ClockCycles = 4;
				throw new NotImplementedException ();
				break;


				//STOP

			case 0x10:

				secondOpcode = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				if (secondOpcode == 0x00) {
					res.ClockCycles = 4;
					throw new NotImplementedException ();
				}
				break;


				//DI

			case 0xF3:
				res.ClockCycles = 4;
				throw new NotImplementedException ();

				break;


				//EI
			case 0xFB:
				res.ClockCycles = 4;
				throw new NotImplementedException ();
				break;
			}


			return res.ClockCycles > 0 ? res : null;
		}
	}
}

