using System;

namespace GBEmu.Emulation
{
	public class LD8 : OpcodeProcessor
	{
    internal static UInt16[] Opcodes {
      get {
        return new UInt16[]
        { 0x06, 0x0E, 0x16, 0x1E, 0x26, 0x2E, 0x7F, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 
          0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E,
          0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x36, 0x0A, 0x1A, 0xFA, 0x3E, 0x47, 0x4F, 0x57, 0x5F, 0x67, 0x6F, 0x02, 0x12, 0x77, 0xEA, 0xF2, 0xE2, 0x3A, 0x32, 0x22, 0xE0, 0xF0
        };
      }
    }

		public LD8 (UInt16 opcode) : base(opcode)
		{
		}

		public override UInt16[] HandledOpcodes {
			get {
        return LD8.Opcodes;
			}
		}

		protected override void RunInternal(IRegisterAccess registers, IMemoryAccess memoryAccess)
    {
      Register? registerToSet = null;
      Register? registerToRead = null;

      Func<byte> readAction = () => registers.GetSingleRegister(registerToRead.Value);
      Action<byte> writeAction = (b) => registers.SetSingleRegister(registerToSet.Value, b);

      byte upperByte = Opcode.GetUpperByte();
      byte lowerByte = Opcode.GetLowerByte();

      if (upperByte < 0x40)
      {
        throw new NotImplementedException();
      }
      else
      {
        if (upperByte < 0x50)
        {
          if (lowerByte < 0x8)
            registerToSet = Register.B;
          else
            registerToSet = Register.C;
        }
        else if (upperByte < 0x60)
        {
          if (lowerByte < 0x8)
            registerToSet = Register.D;
          else
            registerToSet = Register.E;
        }
        else if (upperByte < 0x70)
        {
          if (lowerByte < 0x8)
            registerToSet = Register.H;
          else
            registerToSet = Register.L;
        }
        else if (upperByte < 0x80)
        {
          if (lowerByte < 0x8)
            writeAction = (b) => memoryAccess.WriteAtAddress(registers.GetDoubleRegister(Register.HL), b);
          else
            registerToSet = Register.A;
        }


        if(lowerByte == 0x00 || lowerByte == 0x8)
          registerToRead = Register.B;
        else if(lowerByte == 0x1 || lowerByte == 0x9)
          registerToRead = Register.C;
        else if(lowerByte == 0x2 || lowerByte == 0xA)
          registerToRead = Register.D;
        else if(lowerByte == 0x3 || lowerByte == 0xB)
          registerToRead = Register.E;
        else if(lowerByte == 0x4 || lowerByte == 0xC)
          registerToRead = Register.H;
        else if(lowerByte == 0x5 || lowerByte == 0xD)
          registerToRead = Register.L;
        else if(lowerByte == 0x6 || lowerByte == 0xE)
          readAction = () => memoryAccess.ReadByteAtAddress(registers.GetDoubleRegister(Register.HL));
        else if(lowerByte == 0x7 || lowerByte == 0xF)
          registerToRead = Register.A;

      }

      var val = readAction();

      writeAction(val);
		}
	}
}

