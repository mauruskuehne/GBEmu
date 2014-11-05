using System;

namespace GBEmu.Emulation
{
	public enum Register
	{
		A,
		B,
		C,
		D,
		E,
		H,
		L,
		Flags,

		AF,
		BC,
		DE,
		HL,
    SP
	}

	public class Registers : IRegisterAccess
	{
		#region Registers and Flags

		//Registers
		public byte A, B, C, D, E, H, L;
		//StackPointer / Program Counter
		public UInt16 SP, PC;

		//Flags (as bits)
		//0-3: nothing
		//4: Carry Flag, this bit is set if a carry occurred from the last math operation if register A is the smaller value when executen the CP instruction
		//5: Half Carry Flag, this bit is set if a carry occurred from the lower nibble in the last math operation
		//6: Subtract Flag, This bit is set if a subtraction wa performed in the last math instruction
		//7: Zero Flag, this bit is set when the result of a math operation is zero or two values match when using the cp instruction
		public byte F;

		public byte GetSingleRegister (Register register)
		{
			switch (register) {
			case Register.A:
				return A;
			case Register.B:
				return B;
			case Register.C:
				return C;
			case Register.D:
				return D;
			case Register.E:
				return E;
			case Register.H:
				return H;
			case Register.L:
				return L;
			case Register.Flags:
				return F;
			default:
				throw new InvalidOperationException ("use GetDoubleRegister");
			}
		}

		public void SetSingleRegister (Register register, byte val)
		{
			switch (register) {
			case Register.A:
				A = val;
				break;
			case Register.B:
				B = val;
				break;
			case Register.C:
				C = val;
				break;
			case Register.D:
				D = val;
				break;
			case Register.E:
				E = val;
				break;
			case Register.H:
				H = val;
				break;
			case Register.L:
				L = val;
				break;
			case Register.Flags:
				F = val;
				break;
			default:
				throw new InvalidOperationException ("use SetDoubleRegister");
			}
		}

		public UInt16 GetDoubleRegister (Register register)
		{
			switch (register) {
			case Register.AF:
				return AF;
			case Register.BC:
				return BC;
			case Register.DE:
				return DE;
			case Register.HL:
				return HL;
      case Register.SP:
        return SP;
			default:
				throw new InvalidOperationException ("use GetSingleRegister");
			}
		}

		public void SetDoubleRegister (Register register, UInt16 value)
		{
			switch (register) {
			case Register.AF:
				AF = value;
				break;
			case Register.BC:
				BC = value;
				break;
			case Register.DE:
				DE = value;
				break;
			case Register.HL:
				HL = value;
				break;
      case Register.SP:
        HL = value;
        break;
			default:
				throw new InvalidOperationException ("use SetSingleRegister");
			}
		}

		public UInt16 GetPC (UInt16 amount = 1, bool peek = false)
		{
			var pc = PC;
			if(!peek)
				PC += amount;
			return pc;
		}

		public UInt16 AF {
			get {
				var shiftedA = A << 8;
				var finalVal = shiftedA + F;
				return (UInt16)finalVal;
			}
			set {
				A = value.GetUpperByte ();
				F = value.GetLowerByte ();
			}
		}

		public UInt16 BC {
			get {
				var shiftedB = B << 8;
				var finalVal = shiftedB + C;
				return (UInt16)finalVal;
			}
			set {
				B = value.GetUpperByte ();
				C = value.GetLowerByte ();
			}
		}

		public UInt16 DE {
			get {
				var shiftedD = D << 8;
				var finalVal = shiftedD + E;
				return (UInt16)finalVal;
			}
			set {
				D = value.GetUpperByte ();
				E = value.GetLowerByte ();
			}
		}

		public UInt16 HL {
			get {
				var shiftedH = H << 8;
				var finalVal = shiftedH + L;
				return (UInt16)finalVal;
			}
			set {
				H = value.GetUpperByte ();
				L = value.GetLowerByte ();
			}
		}

		#endregion

		public void SetFlagForUnsignedByteOperation (Operation addition, byte val1 = 0, byte val2 = 0)
		{
			this.SetFlagForUInt32Operation (addition, val1, (UInt32)val2, 0x0F);
		}

		public void SetFlagForSignedOperation (Operation addition, UInt32 val1, Int32 val2)
		{
			this.SetFlagForUInt32Operation (addition, val1, (UInt32)val2);
		}

		public void SetFlagForUInt32Operation (Operation addition, UInt32 val1, UInt32 val2, int halfCarryMask = 0x00FF)
		{
			//Flags (as bits)
			//0-3: nothing(1,2,4)
			//4: Carry Flag, this bit is set if a carry occurred from the last math operation if register A is the smaller value when executen the CP instruction
			//5: Half Carry Flag, this bit is set if a carry occurred from the lower nibble in the last math operation
			//6: Subtract Flag, This bit is set if a subtraction wa performed in the last math instruction
			//7: Zero Flag, this bit is set when the result of a math operation is zero or two values match when using the cp instruction

			Flags newFlags = 0;

			var uVal1 = (UInt32)val1;
			var uVal2 = (UInt32)val2;

			switch (addition) {
			case Operation.Addition:
				//called before exection
				if (((uVal1 & halfCarryMask) + (uVal1 & halfCarryMask)) > halfCarryMask) {
					newFlags |= Flags.H;
				}
				if (Convert.ToInt32 (val1) + Convert.ToInt32 (val2) > UInt16.MaxValue) {
					newFlags |= Flags.C;
				}
				if (Convert.ToInt32 (val1) + Convert.ToInt32 (val2) == 0) {
					newFlags |= Flags.Z;
				}
				//if (Convert.ToInt32 (val2) < 0) {
				//	newFlags |= Flags.N;
				//}
				break;

        case Operation.BIT:

          if ((val1 & val2) == 0)
            newFlags |= Flags.Z;

          newFlags |= Flags.H;

          newFlags |= (Flags)(((byte)Flags.C) & this.F);

          break;

			case Operation.Shift:

				if (val1 == 0)
					newFlags |= Flags.Z;

				if (val2 != 0)
					newFlags |= Flags.C;

				break;

			case Operation.RLCA:
				//called after execution
				if (val1 == 0)
					newFlags |= Flags.Z;

				if ((val1 & 1) == 1)
					newFlags |= Flags.C;

				break;

			case Operation.RLA_OR_RRA:
				//called after execution
				if (val1 == 0)
					newFlags |= Flags.Z;

				if (val2 != 0)
					newFlags |= Flags.C;

				break;

			case Operation.RRCA:
				//called after execution
				if (val1 == 0)
					newFlags |= Flags.Z;

				if ((val1 & 0xFF) > 1)
					newFlags |= Flags.C;

				break;

			case Operation.ADDSP:
				//called after execution
				if (((uVal1 & halfCarryMask) + (uVal1 & halfCarryMask)) > halfCarryMask) {
					newFlags |= Flags.H;
				}

				break;

			case Operation.CPL:

				newFlags = (Flags)(F & (byte)(Flags.Z | Flags.C));

				newFlags |= Flags.N | Flags.H;

				break;

			case Operation.CCF:
				newFlags = (Flags)(F & (byte)(Flags.Z));

				newFlags |= (Flags) ~(F & (byte)Flags.C);

				break;

			case Operation.SCF:

				newFlags |= Flags.C;

				break;

			case Operation.Subtraction:
				//called before execution
				//subtract the upper two bytes, if this results in a value < 16, half carry is set
				if (((uVal1 & ~halfCarryMask) - (uVal1 & ~halfCarryMask)) < 16) {
					newFlags |= Flags.H;
				}
				if (Convert.ToInt32 (val1) - Convert.ToInt32 (val2) < 0) {
					newFlags |= Flags.C;
				}
				if (Convert.ToInt32 (val1) - Convert.ToInt32 (val2) == 0) {
					newFlags |= Flags.Z;
				}

				newFlags |= Flags.N;
				break;

			case Operation.AND:
				//called before execution
				if ((uVal1 & uVal2) == 0)
					newFlags |= Flags.Z;

				newFlags |= Flags.H;

				break;

			case Operation.OR:
				//called before execution
				if ((uVal1 | uVal2) == 0)
					newFlags |= Flags.Z;
				break;
			case Operation.XOR:
				//called before execution
				if ((uVal1 ^ uVal2) == 0)
					newFlags |= Flags.Z;
				break;

			case Operation.SWAP:
				//called after execution
				if (val1 == 0)
					newFlags |= Flags.Z;

				break;

			default:
				break;
			}

			this.F = (byte)newFlags;
		}

		/// <summary>
		/// 1 wenn gesetzt, 0 wenn nicht
		/// </summary>
		/// <returns>The flag.</returns>
		/// <param name="flag">Flag.</param>
		public byte GetFlag(Flags flag)
		{
			return (byte)(((this.F & ((byte)flag)) > 0) ? 1 : 0);
		}

		public void ResetFlags (Flags flags)
		{
			this.F &= (byte)~flags;
		}
	}
}

