using System;

namespace GBEmu.Emulation
{
	public class Registers
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
		public byte Flags;

		public UInt16 GetPC()
		{
			return PC++;
		}

		public UInt16 AF {
			get
			{
				var shiftedA = A << 8;
				var finalVal = shiftedA + Flags;
				return (UInt16)finalVal;
			}
			set
			{
				A = value.GetUpperByte ();
				Flags = value.GetLowerByte ();
			}
		}

		public UInt16 BC {
			get
			{
				var shiftedB = B << 8;
				var finalVal = shiftedB + C;
				return (UInt16)finalVal;
			}
			set
			{
				B = value.GetUpperByte ();
				C = value.GetLowerByte ();
			}
		}

		public UInt16 DE {
			get
			{
				var shiftedD = D << 8;
				var finalVal = shiftedD + E;
				return (UInt16)finalVal;
			}
			set
			{
				D = value.GetUpperByte ();
				E = value.GetLowerByte ();
			}
		}

		public UInt16 HL {
			get
			{
				var shiftedH = H << 8;
				var finalVal = shiftedH + L;
				return (UInt16)finalVal;
			}
			set
			{
				H = value.GetUpperByte ();
				L = value.GetLowerByte ();
			}
		}

		#endregion
	}
}

