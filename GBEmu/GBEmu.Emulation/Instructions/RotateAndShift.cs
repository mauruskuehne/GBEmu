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

				var nextOpcode = memoryAccess.ReadByteAtAddress (registers.GetPC (peek: true));

				switch (nextOpcode) {

				//RLC n

				case 0x07:
					bit7Val = (byte)(registers.A & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((registers.A << 1) + newFirstBit);
					registers.A = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLCA, registers.A);
					res.ClockCycles = 8;
					break;
				case 0x00:
					bit7Val = (byte)(registers.B & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((registers.B << 1) + newFirstBit);
					registers.B = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLCA, registers.B);
					res.ClockCycles = 8;
					break;
				case 0x01:
					bit7Val = (byte)(registers.C & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((registers.C << 1) + newFirstBit);
					registers.C = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLCA, registers.C);
					res.ClockCycles = 8;
					break;
				case 0x02:
					bit7Val = (byte)(registers.D & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((registers.D << 1) + newFirstBit);
					registers.D = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLCA, registers.D);
					res.ClockCycles = 8;
					break;
				case 0x03:
					bit7Val = (byte)(registers.E & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((registers.E << 1) + newFirstBit);
					registers.E = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLCA, registers.E);
					res.ClockCycles = 8;
					break;
				case 0x04:
					bit7Val = (byte)(registers.H & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((registers.H << 1) + newFirstBit);
					registers.H = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLCA, registers.H);
					res.ClockCycles = 8;
					break;
				case 0x05:
					bit7Val = (byte)(registers.L & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((registers.L << 1) + newFirstBit);
					registers.L = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLCA, registers.L);
					res.ClockCycles = 8;
					break;
				case 0x06:
					byte oldVal = memoryAccess.ReadByteAtAddress (registers.HL);
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + newFirstBit);
					memoryAccess.WriteAtAddress (registers.HL, newVal);
					registers.SetFlagForUnsignedByteOperation (Operation.RLCA, newVal);
					res.ClockCycles = 16;
					break;

					//RL n

				case 0x17:
					oldVal = registers.A;
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)( bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + registers.GetFlag(Flags.C));
					registers.A = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newFirstBit);
					res.ClockCycles = 8;
					break;
				case 0x10:
					oldVal = registers.B;
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)( bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + registers.GetFlag(Flags.C));
					registers.B = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newFirstBit);
					res.ClockCycles = 8;
					break;
				case 0x11:
					oldVal = registers.C;
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)( bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + registers.GetFlag(Flags.C));
					registers.C = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newFirstBit);
					res.ClockCycles = 8;
					break;
				case 0x12:
					oldVal = registers.D;
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)( bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + registers.GetFlag(Flags.C));
					registers.D = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newFirstBit);
					res.ClockCycles = 8;
					break;
				case 0x13:
					oldVal = registers.E;
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)( bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + registers.GetFlag(Flags.C));
					registers.E = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newFirstBit);
					res.ClockCycles = 8;
					break;
				case 0x14:
					oldVal = registers.H;
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)( bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + registers.GetFlag(Flags.C));
					registers.H = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newFirstBit);
					res.ClockCycles = 8;
					break;
				case 0x15:
					oldVal = registers.L;
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)( bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + registers.GetFlag(Flags.C));
					registers.L = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newFirstBit);
					res.ClockCycles = 8;
					break;
				case 0x16:
					oldVal = memoryAccess.ReadByteAtAddress (registers.HL);
					bit7Val = (byte)(oldVal & 0xFF);
					newFirstBit = (byte)(bit7Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal << 1) + registers.GetFlag (Flags.C));
					memoryAccess.WriteAtAddress (registers.HL, newVal);
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newFirstBit);
					res.ClockCycles = 8;
					break;

					//RRC n

				case 0x0F:
					oldVal = registers.A;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);
					newVal = (byte)((oldVal >> 1) + newLastBit);
					registers.A = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RRCA, newVal);
					res.ClockCycles = 8;
					break;
				case 0x08:
					oldVal = registers.B;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);
					newVal = (byte)((oldVal >> 1) + newLastBit);
					registers.B = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RRCA, newVal);
					res.ClockCycles = 8;
					break;
				case 0x09:
					oldVal = registers.C;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);
					newVal = (byte)((oldVal >> 1) + newLastBit);
					registers.C = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RRCA, newVal);
					res.ClockCycles = 8;
					break;
				case 0x0A:
					oldVal = registers.D;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);
					newVal = (byte)((oldVal >> 1) + newLastBit);
					registers.D = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RRCA, newVal);
					res.ClockCycles = 8;
					break;
				case 0x0B:
					oldVal = registers.E;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);
					newVal = (byte)((oldVal >> 1) + newLastBit);
					registers.E = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RRCA, newVal);
					res.ClockCycles = 8;
					break;
				case 0x0C:
					oldVal = registers.H;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);
					newVal = (byte)((oldVal >> 1) + newLastBit);
					registers.H = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RRCA, newVal);
					res.ClockCycles = 8;
					break;
				case 0x0D:
					oldVal = registers.L;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);
					newVal = (byte)((oldVal >> 1) + newLastBit);
					registers.L = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RRCA, newVal);
					res.ClockCycles = 8;
					break;
				case 0x0E:
					oldVal = memoryAccess.ReadByteAtAddress (registers.HL);
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 0xFF);
					newVal = (byte)((oldVal >> 1) + newLastBit);
					memoryAccess.WriteAtAddress (registers.HL, newVal);
					registers.SetFlagForUnsignedByteOperation (Operation.RRCA, newVal);
					res.ClockCycles = 16;
					break;


					//RR n


				case 0x1F:
					oldVal = registers.A;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)( bit0Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal >> 1) + (registers.GetFlag(Flags.C) == 1 ? 0xFF : 0));
					registers.A = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newLastBit);
					res.ClockCycles = 8;
					break;
				case 0x18:
					oldVal = registers.B;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)( bit0Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal >> 1) + (registers.GetFlag(Flags.C) == 1 ? 0xFF : 0));
					registers.B = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newLastBit);
					res.ClockCycles = 8;
					break;
				case 0x19:
					oldVal = registers.C;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)( bit0Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal >> 1) + (registers.GetFlag(Flags.C) == 1 ? 0xFF : 0));
					registers.C = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newLastBit);
					res.ClockCycles = 8;
					break;
				case 0x1A:
					oldVal = registers.D;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)( bit0Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal >> 1) + (registers.GetFlag(Flags.C) == 1 ? 0xFF : 0));
					registers.D = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newLastBit);
					res.ClockCycles = 8;
					break;
				case 0x1B:
					oldVal = registers.E;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)( bit0Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal >> 1) + (registers.GetFlag(Flags.C) == 1 ? 0xFF : 0));
					registers.E = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newLastBit);
					res.ClockCycles = 8;
					break;
				case 0x1C:
					oldVal = registers.H;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)( bit0Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal >> 1) + (registers.GetFlag(Flags.C) == 1 ? 0xFF : 0));
					registers.H = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newLastBit);
					res.ClockCycles = 8;
					break;
				case 0x1D:
					oldVal = registers.L;
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)( bit0Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal >> 1) + (registers.GetFlag(Flags.C) == 1 ? 0xFF : 0));
					registers.L = newVal;
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newLastBit);
					res.ClockCycles = 8;
					break;
				case 0x1E:
					oldVal = memoryAccess.ReadByteAtAddress (registers.HL);
					bit0Val = (byte)(oldVal & 0x01);
					newLastBit = (byte)(bit0Val == 0 ? 0 : 1);
					newVal = (byte)((oldVal >> 1) + (registers.GetFlag (Flags.C) == 1 ? 0xFF : 0));
					memoryAccess.WriteAtAddress (registers.HL, newVal);
					registers.SetFlagForUnsignedByteOperation (Operation.RLA_OR_RRA, newVal, newLastBit);
					res.ClockCycles = 8;
					break;

					//SLA n

				case 0x27:
					RotateAndShift.SLA_n (() => registers.A, (val) => registers.A = val, registers);
					res.ClockCycles = 8;
					break;
				case 0x20:
					RotateAndShift.SLA_n (() => registers.B, (val) => registers.B = val, registers);
					res.ClockCycles = 8;
					break;
				case 0x21:
					RotateAndShift.SLA_n (() => registers.C, (val) => registers.C = val, registers);
					res.ClockCycles = 8;
					break;
				case 0x22:
					RotateAndShift.SLA_n (() => registers.D, (val) => registers.D = val, registers);
					res.ClockCycles = 8;
					break;
				case 0x23:
					RotateAndShift.SLA_n (() => registers.E, (val) => registers.E = val, registers);
					res.ClockCycles = 8;
					break;
				case 0x24:
					RotateAndShift.SLA_n (() => registers.H, (val) => registers.H = val, registers);
					res.ClockCycles = 8;
					break;
				case 0x25:
					RotateAndShift.SLA_n (() => registers.L, (val) => registers.L = val, registers);
					res.ClockCycles = 8;
					break;
				case 0x26:

					RotateAndShift.SLA_n (
						() => memoryAccess.ReadByteAtAddress (registers.HL), 
						(val) => memoryAccess.WriteAtAddress (registers.HL, val), registers);

					res.ClockCycles = 16;
					break;

					//SRA n

				case 0x2F:
					RotateAndShift.SRA_n (() => registers.A, (v) => registers.A = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x28:
					RotateAndShift.SRA_n (() => registers.B, (v) => registers.B = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x29:
					RotateAndShift.SRA_n (() => registers.C, (v) => registers.C = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x2A:
					RotateAndShift.SRA_n (() => registers.D, (v) => registers.D = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x2B:
					RotateAndShift.SRA_n (() => registers.E, (v) => registers.E = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x2C:
					RotateAndShift.SRA_n (() => registers.H, (v) => registers.H = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x2D:
					RotateAndShift.SRA_n (() => registers.L, (v) => registers.L = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x2E:
					RotateAndShift.SRA_n (
						() => memoryAccess.ReadByteAtAddress (registers.HL), 
						(val) => memoryAccess.WriteAtAddress (registers.HL, val), 
						registers);
					res.ClockCycles = 16;
					break;

					//SRL n
				case 0x3F:
					RotateAndShift.SRL_n (() => registers.A, (v) => registers.A = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x38:
					RotateAndShift.SRL_n (() => registers.B, (v) => registers.B = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x39:
					RotateAndShift.SRL_n (() => registers.C, (v) => registers.C = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x3A:
					RotateAndShift.SRL_n (() => registers.D, (v) => registers.D = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x3B:
					RotateAndShift.SRL_n (() => registers.E, (v) => registers.E = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x3C:
					RotateAndShift.SRL_n (() => registers.H, (v) => registers.H = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x3D:
					RotateAndShift.SRL_n (() => registers.L, (v) => registers.L = v, registers);
					res.ClockCycles = 8;
					break;
				case 0x3E:
					RotateAndShift.SRL_n (
						() => memoryAccess.ReadByteAtAddress (registers.HL), 
						(val) => memoryAccess.WriteAtAddress (registers.HL, val), 
						registers);
					res.ClockCycles = 16;
					break;


				default:
					break;
				}

				if (res.ClockCycles > 0)
					registers.GetPC ();


				break;
			}


			return res.ClockCycles > 0 ? res : null;
		}

		private static void SLA_n(Func<byte> readValue, Action<byte> writeValue, Registers registers)
		{
			var oldVal = readValue();
			var bit7Val =(byte)( oldVal & 0xFF);
			var newVal = (byte)(oldVal << 1);
			registers.SetFlagForUnsignedByteOperation (Operation.Shift, newVal, bit7Val);
			registers.A = newVal;
			writeValue (newVal);
		}

		private static void SRA_n(Func<byte> readValue, Action<byte> writeValue, Registers registers)
		{
			var oldVal = readValue();
			var bit7Val = (byte)( oldVal & 0xFF);
			var bit0Val = (byte)(oldVal & 0x1);
			byte newVal = (byte)( (oldVal >> 1) | bit7Val);
			registers.SetFlagForUnsignedByteOperation (Operation.Shift, newVal, bit0Val);
			writeValue (newVal);
		}

		private static void SRL_n(Func<byte> readValue, Action<byte> writeValue, Registers registers)
		{
			var oldVal = readValue();
			var bit0Val = (byte)(oldVal & 0x1);
			byte newVal = (byte)(oldVal >> 1);
			registers.SetFlagForUnsignedByteOperation (Operation.Shift, newVal, bit0Val);
			writeValue (newVal);
		}
	}
}

