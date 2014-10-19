using System;

namespace GBEmu.Emulation
{
	public class CPU
	{
		//Registers
		byte _a, _b, _c, _d, _e, _f, _h, _l;
		//StackPointer / Program Counter
		UInt16 _sp, _pc;

		//Flags (as bits)
		//0-3: nothing
		//4: Carry Flag, this bit is set if a carry occurred from the last math operation if register A is the smaller value when executen the CP instruction
		//5: Half Carry Flag, this bit is set if a carry occurred from the lower nibble in the last math operation
		//6: Subtract Flag, This bit is set if a subtraction wa performed in the last math instruction
		//7: Zero Flag, this bit is set when the result of a math operation is zero or two values match when using the cp instruction
		byte _flags;

		private UInt16 AF {
			get
			{
				var shiftedA = _a << 8;
				var finalVal = shiftedA + _f;
				return (UInt16)finalVal;
			}
			set
			{
				_a = value.GetUpperByte ();
				_f = value.GetLowerByte ();
			}
		}

		private UInt16 BC {
			get
			{
				var shiftedB = _b << 8;
				var finalVal = shiftedB + _c;
				return (UInt16)finalVal;
			}
			set
			{
				_b = value.GetUpperByte ();
				_c = value.GetLowerByte ();
			}
		}

		private UInt16 DE {
			get
			{
				var shiftedD = _d << 8;
				var finalVal = shiftedD + _e;
				return (UInt16)finalVal;
			}
			set
			{
				_d = value.GetUpperByte ();
				_e = value.GetLowerByte ();
			}
		}

		private UInt16 HL {
			get
			{
				var shiftedH = _h << 8;
				var finalVal = shiftedH + _l;
				return (UInt16)finalVal;
			}
			set
			{
				_h = value.GetUpperByte ();
				_l = value.GetLowerByte ();
			}
		}

		MemoryAccess _memoryAccess;

		public CPU (MemoryAccess _memoryAccess)
		{
			this._memoryAccess = _memoryAccess;
		}

		public void Reset ()
		{
			_sp = 0xFFFE;
			_pc = 0x100;
		}

		public void Start ()
		{
		}
	}
}

