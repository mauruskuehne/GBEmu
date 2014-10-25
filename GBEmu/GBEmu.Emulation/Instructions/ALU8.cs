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
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, registers.A);
				registers.A += registers.A;
				res.ClockCycles = 4;
				break;
			case 0x80: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, registers.B);
				registers.A += registers.B;
				res.ClockCycles = 4;
				break;
			case 0x81: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, registers.C);
				registers.A += registers.C;
				res.ClockCycles = 4;
				break;
			case 0x82: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, registers.D);
				registers.A += registers.D;
				res.ClockCycles = 4;
				break;
			case 0x83: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, registers.E);
				registers.A += registers.E;
				res.ClockCycles = 4;
				break;
			case 0x84: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, registers.H);
				registers.A += registers.H;
				res.ClockCycles = 4;
				break;
			case 0x85: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, registers.L);
				registers.A += registers.L;
				res.ClockCycles = 4;
				break;
			case 0x86: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 8;
				break;
			case 0xC6: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 8;
				break;

			//ADC A,n

			case 0x8F: 
				valU8 = (byte)(registers.A + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 4;
				break;
			case 0x88: 
				valU8 = (byte)(registers.B + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 4;
				break;
			case 0x89: 
				valU8 = (byte)(registers.C + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 4;
				break;
			case 0x8A: 
				valU8 = (byte)(registers.D + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 4;
				break;
			case 0x8B: 
				valU8 = (byte)(registers.E + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 4;
				break;
			case 0x8C: 
				valU8 = (byte)(registers.H + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 4;
				break;
			case 0x8D: 
				valU8 = (byte)(registers.L + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 4;
				break;
			case 0x8E: 
				valU8 = (byte)(memoryAccess.ReadByteAtAddress (registers.HL) + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 8;
				break;
			case 0xCE: 
				valU8 = (byte)(memoryAccess.ReadByteAtAddress (registers.GetPC ()) + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, valU8);
				registers.A += valU8;
				res.ClockCycles = 8;
				break;


				//SUB n

			case 0x97: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.A);
				registers.A -= registers.A;
				res.ClockCycles = 4;
				break;
			case 0x90: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.B);
				registers.A -= registers.B;
				res.ClockCycles = 4;
				break;
			case 0x91: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.C);
				registers.A -= registers.C;
				res.ClockCycles = 4;
				break;
			case 0x92: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.D);
				registers.A -= registers.D;
				res.ClockCycles = 4;
				break;
			case 0x93: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.E);
				registers.A -= registers.E;
				res.ClockCycles = 4;
				break;
			case 0x94: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.H);
				registers.A -= registers.H;
				res.ClockCycles = 4;
				break;
			case 0x95: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.L);
				registers.A -= registers.L;
				res.ClockCycles = 4;
				break;
			case 0x96: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 8;
				break;
			case 0xD6: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 8;
				break;

				// SBC A,n

			case 0x9F: 
				valU8 = (byte)(registers.A + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 4;
				break;
			case 0x98: 
				valU8 = (byte)(registers.B + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 4;
				break;
			case 0x99: 
				valU8 = (byte)(registers.C + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 4;
				break;
			case 0x9A: 
				valU8 = (byte)(registers.D + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 4;
				break;
			case 0x9B: 
				valU8 = (byte)(registers.E + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 4;
				break;
			case 0x9C: 
				valU8 = (byte)(registers.H + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 4;
				break;
			case 0x9D: 
				valU8 = (byte)(registers.L + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 4;
				break;
			case 0x9E: 
				valU8 = (byte)(memoryAccess.ReadByteAtAddress (registers.HL) + registers.GetFlag (Flags.C));
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 8;
				break;

				//apparently there is no equivalent to this for SBC?
			/*case 0xCE: 
				valU8 = (byte)(memoryAccess.ReadByteAtAddress (registers.GetPC ()) + registers.GetFlag (Flags.C));
				registers.SetFlagForOperation (Operation.Subtraction, registers.A, valU8);
				registers.A -= valU8;
				res.ClockCycles = 8;
				break;*/


				//AND n

			case 0xA7:
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, registers.A);
				registers.A &= registers.A;
				res.ClockCycles = 4;
				break;
			case 0xA0:
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, registers.B);
				registers.A &= registers.B;
				res.ClockCycles = 4;
				break;
			case 0xA1:
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, registers.C);
				registers.A &= registers.C;
				res.ClockCycles = 4;
				break;
			case 0xA2:
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, registers.D);
				registers.A &= registers.D;
				res.ClockCycles = 4;
				break;
			case 0xA3:
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, registers.E);
				registers.A &= registers.E;
				res.ClockCycles = 4;
				break;
			case 0xA4:
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, registers.H);
				registers.A &= registers.H;
				res.ClockCycles = 4;
				break;
			case 0xA5:
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, registers.L);
				registers.A &= registers.L;
				res.ClockCycles = 4;
				break;
			case 0xA6:
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, valU8);
				registers.A &= valU8;
				res.ClockCycles = 8;
				break;
			case 0xE6:
				valU8 = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				registers.SetFlagForUnsignedByteOperation (Operation.AND, registers.A, valU8);
				registers.A &= valU8;
				res.ClockCycles = 8;
				break;


				// OR n

			case 0xB7:
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, registers.A);
				registers.A |= registers.A;
				res.ClockCycles = 4;
				break;
			case 0xB0:
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, registers.B);
				registers.A |= registers.B;
				res.ClockCycles = 4;
				break;
			case 0xB1:
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, registers.C);
				registers.A |= registers.C;
				res.ClockCycles = 4;
				break;
			case 0xB2:
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, registers.D);
				registers.A |= registers.D;
				res.ClockCycles = 4;
				break;
			case 0xB3:
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, registers.E);
				registers.A |= registers.E;
				res.ClockCycles = 4;
				break;
			case 0xB4:
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, registers.H);
				registers.A |= registers.H;
				res.ClockCycles = 4;
				break;
			case 0xB5:
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, registers.L);
				registers.A |= registers.L;
				res.ClockCycles = 4;
				break;
			case 0xB6:
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, valU8);
				registers.A |= valU8;
				res.ClockCycles = 8;
				break;
			case 0xF6:
				valU8 = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				registers.SetFlagForUnsignedByteOperation (Operation.OR, registers.A, valU8);
				registers.A |= valU8;
				res.ClockCycles = 8;
				break;


				// XOR n

			case 0xAF:
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, registers.A);
				registers.A ^= registers.A;
				res.ClockCycles = 4;
				break;
			case 0xA8:
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, registers.B);
				registers.A ^= registers.B;
				res.ClockCycles = 4;
				break;
			case 0xA9:
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, registers.C);
				registers.A ^= registers.C;
				res.ClockCycles = 4;
				break;
			case 0xAA:
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, registers.D);
				registers.A ^= registers.D;
				res.ClockCycles = 4;
				break;
			case 0xAB:
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, registers.E);
				registers.A ^= registers.E;
				res.ClockCycles = 4;
				break;
			case 0xAC:
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, registers.H);
				registers.A ^= registers.H;
				res.ClockCycles = 4;
				break;
			case 0xAD:
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, registers.L);
				registers.A ^= registers.L;
				res.ClockCycles = 4;
				break;
			case 0xAE:
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, valU8);
				registers.A ^= valU8;
				res.ClockCycles = 8;
				break;
			case 0xEE:
				valU8 = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				registers.SetFlagForUnsignedByteOperation (Operation.XOR, registers.A, valU8);
				registers.A ^= valU8;
				res.ClockCycles = 8;
				break;

				// CP n
			case 0xBF:
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.A);
				res.ClockCycles = 4;
				break;
			case 0xB8:
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.B);
				res.ClockCycles = 4;
				break;
			case 0xB9:
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.C);
				res.ClockCycles = 4;
				break;
			case 0xBA:
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.D);
				res.ClockCycles = 4;
				break;
			case 0xBB:
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.E);
				res.ClockCycles = 4;
				break;
			case 0xBC:
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.H);
				res.ClockCycles = 4;
				break;
			case 0xBD:
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, registers.L);
				res.ClockCycles = 4;
				break;
			case 0xBE:
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				res.ClockCycles = 8;
				break;
			case 0xFE:
				valU8 = memoryAccess.ReadByteAtAddress (registers.GetPC ());
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, valU8);
				res.ClockCycles = 8;
				break;


				// INC n

			case 0x3C: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.A, 1);
				registers.A += 1;
				res.ClockCycles = 4;
				break;
			case 0x04: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.B, 1);
				registers.B += 1;
				res.ClockCycles = 4;
				break;
			case 0x0C: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.C, 1);
				registers.C += 1;
				res.ClockCycles = 4;
				break;
			case 0x14: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.D, 1);
				registers.D += 1;
				res.ClockCycles = 4;
				break;
			case 0x1C: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.E, 1);
				registers.E += 1;
				res.ClockCycles = 4;
				break;
			case 0x24: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.H, 1);
				registers.H += 1;
				res.ClockCycles = 4;
				break;
			case 0x2C: 
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, registers.L, 1);
				registers.L += 1;
				res.ClockCycles = 4;
				break;
			case 0x34: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForUnsignedByteOperation (Operation.Addition, valU8, 1);
				memoryAccess.WriteAtAddress (registers.HL, (byte)( valU8 + 1));
				res.ClockCycles = 12;
				break;


				// DEC n

			case 0x3D: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.A, 1);
				registers.A -= 1;
				res.ClockCycles = 4;
				break;
			case 0x05: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.B, 1);
				registers.B -= 1;
				res.ClockCycles = 4;
				break;
			case 0x0D: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.C, 1);
				registers.C -= 1;
				res.ClockCycles = 4;
				break;
			case 0x15: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.D, 1);
				registers.D -= 1;
				res.ClockCycles = 4;
				break;
			case 0x1D: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.E, 1);
				registers.E -= 1;
				res.ClockCycles = 4;
				break;
			case 0x25: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.H, 1);
				registers.H -= 1;
				res.ClockCycles = 4;
				break;
			case 0x2D: 
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, registers.L, 1);
				registers.L -= 1;
				res.ClockCycles = 4;
				break;
			case 0x35: 
				valU8 = memoryAccess.ReadByteAtAddress (registers.HL);
				registers.SetFlagForUnsignedByteOperation (Operation.Subtraction, valU8, 1);
				memoryAccess.WriteAtAddress (registers.HL, (byte)( valU8 - 1));
				res.ClockCycles = 12;
				break;
			
			}

			return res.ClockCycles > 0 ? res : null;
		}
	}
}

