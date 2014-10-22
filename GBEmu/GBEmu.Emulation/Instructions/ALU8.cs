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
			//ADD A,n
			case 0x87: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.A);
				registers.A += registers.A;
				res.ClockCycles = 4;
				break;
			case 0x80: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.B);
				registers.A += registers.B;
				res.ClockCycles = 4;
				break;
			case 0x81: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.C);
				registers.A += registers.C;
				res.ClockCycles = 4;
				break;
			case 0x82: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.D);
				registers.A += registers.D;
				res.ClockCycles = 4;
				break;
			case 0x83: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.E);
				registers.A += registers.E;
				res.ClockCycles = 4;
				break;
			case 0x84: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.H);
				registers.A += registers.H;
				res.ClockCycles = 4;
				break;
			case 0x85: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.L);
				registers.A += registers.L;
				res.ClockCycles = 4;
				break;
			case 0x86: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 8;
				break;
			case 0xC6: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				registers.SetFlagForOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 8;
				break;

			//ADC A,n

			case 0x8F: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.A);
				registers.A += (byte)(registers.A + registers.GetFlag (Flags.C));
				res.ClockCycles = 4;
				break;
			case 0x88: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.B);
				registers.A += (byte)(registers.B + registers.GetFlag (Flags.C));
				res.ClockCycles = 4;
				break;
			case 0x89: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.C);
				registers.A += (byte)(registers.C + registers.GetFlag (Flags.C));
				res.ClockCycles = 4;
				break;
			case 0x8A: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.D);
				registers.A += (byte)(registers.D + registers.GetFlag (Flags.C));
				res.ClockCycles = 4;
				break;
			case 0x8B: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.E);
				registers.A += (byte)(registers.E + registers.GetFlag (Flags.C));
				res.ClockCycles = 4;
				break;
			case 0x8C: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.H);
				registers.A += (byte)(registers.H + registers.GetFlag (Flags.C));
				res.ClockCycles = 4;
				break;
			case 0x8D: 
				registers.SetFlagForOperation (Operation.Addition, registers.A, registers.L);
				registers.A += (byte)(registers.L + registers.GetFlag (Flags.C));
				res.ClockCycles = 4;
				break;
			case 0x8E: 
				valU8 = (byte)(memoryAccess.ReadByteAtAddress (registers.HL) + registers.GetFlag (Flags.C));
				registers.SetFlagForOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 8;
				break;
			case 0xCE: 
				valU8 = (byte)(memoryAccess.ReadByteAtAddress (registers.GetPC ()) + registers.GetFlag (Flags.C));
				registers.SetFlagForOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 8;
				break;


				//SUB n

			case 0x97: 
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, registers.A);
				registers.A -= registers.A;
				res.ClockCycles = 4;
				break;
			case 0x90: 
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, registers.B);
				registers.A -= registers.B;
				res.ClockCycles = 4;
				break;
			case 0x91: 
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, registers.C);
				registers.A -= registers.C;
				res.ClockCycles = 4;
				break;
			case 0x92: 
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, registers.D);
				registers.A -= registers.D;
				res.ClockCycles = 4;
				break;
			case 0x93: 
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, registers.E);
				registers.A -= registers.E;
				res.ClockCycles = 4;
				break;
			case 0x94: 
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, registers.H);
				registers.A -= registers.H;
				res.ClockCycles = 4;
				break;
			case 0x95: 
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, registers.L);
				registers.A -= registers.L;
				res.ClockCycles = 4;
				break;
			case 0x96: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 8;
				break;
			case 0xD6: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 8;
				break;
			}

			return res.ClockCycles > 0 ? res : null;
		}
	}
}

