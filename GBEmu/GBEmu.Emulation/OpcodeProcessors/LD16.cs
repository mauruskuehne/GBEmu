using System;

namespace GBEmu.Emulation
{
	public class LD16 : OpcodeProcessor
	{
    internal static UInt16[] Opcodes {
      get {
        return new UInt16[] { 0x01, 0x11, 0x21, 0x31, 0xF9, 0x08 };
      }
    }

		public LD16 (UInt16 opcode) : base(opcode)
		{
		}

		public override UInt16[] HandledOpcodes {
			get {
        return LD16.Opcodes;
			}
		}

		protected override void RunInternal(IRegisterAccess registers, IMemoryAccess memoryAccess)
    {
      Register? registerToSet = null;
      Register? registerToRead = null;

      Func<UInt16> readAction = () => registers.GetDoubleRegister(registerToRead.Value);
      Action<UInt16> writeAction = (b) => registers.SetDoubleRegister(registerToSet.Value, b);

      switch (Opcode)
      {
        case 0x01:
          registerToSet = Register.BC;
          break;
        case 0x11:
          registerToSet = Register.DE;
          break;
        case 0x21:
          registerToSet = Register.HL;
          break;
        case 0x31:
          registerToSet = Register.SP;
          break;
        case 0xF9:
          registerToSet = Register.SP;
          registerToRead = Register.HL;
          break;
        case 0x08:
          writeAction = (b) => memoryAccess.WriteAtAddress(registers.GetPC(2), b);
          registerToRead = Register.SP;
          break;
        default:
          break;
      }

      if (Opcode.GetLowerByte() == 0x1)
        readAction = () => memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), false);



      var val = readAction();

      writeAction(val);
		}
	}
}

