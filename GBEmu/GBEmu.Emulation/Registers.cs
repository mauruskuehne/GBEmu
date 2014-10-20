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
    HL
  }

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

    public byte GetSingleRegister(Register register)
    {
      switch (register)
      {
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
          return Flags;
        default:
          throw new InvalidOperationException("use GetDoubleRegister");
      }
    }

    public void SetSingleRegister(Register register, byte val)
    {
      switch (register)
      {
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
          Flags = val;
          break;
        default:
          throw new InvalidOperationException("use SetDoubleRegister");
      }
    }

    public UInt16 GetDoubleRegister(Register register)
    {
      switch (register)
      {
        case Register.AF:
          return AF;
        case Register.BC:
          return BC;
        case Register.DE:
          return DE;
        case Register.HL:
          return HL;
        default:
          throw new InvalidOperationException("use GetSingleRegister");
      }
    }

    public void SetDoubleRegister(Register register, UInt16 value)
    {
      switch (register)
      {
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
        default:
          throw new InvalidOperationException("use SetSingleRegister");
      }
    }

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

