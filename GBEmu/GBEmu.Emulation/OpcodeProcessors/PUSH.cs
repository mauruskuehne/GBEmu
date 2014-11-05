using System;

namespace GBEmu.Emulation
{
  public class PUSH : OpcodeProcessor
  {
    internal static UInt16[] Opcodes {
      get {
        return new UInt16[] { 0xF5, 0xC5, 0xD5, 0xE5 };
      }
    }

    public PUSH (UInt16 opcode) : base(opcode)
    {
    }

    public override UInt16[] HandledOpcodes {
      get {
        return PUSH.Opcodes;
      }
    }

    protected override void RunInternal(IRegisterAccess registers, IMemoryAccess memoryAccess)
    {
      Register? registerToRead = null;

      registers.SetDoubleRegister(Register.SP, (UInt16) (registers.GetDoubleRegister(Register.SP) - 2));

      switch (Opcode)
      {
        case 0xF5:
          registerToRead = Register.AF;
          break;
        case 0xC5:
          registerToRead = Register.BC;
          break;
        case 0xD5:
          registerToRead = Register.DE;
          break;
        case 0xE5:
          registerToRead = Register.HL;
          break;
        default:
          break;
      }

      memoryAccess.WriteAtAddress(registers.GetDoubleRegister(Register.SP), 
        (UInt16)( registers.GetDoubleRegister(registerToRead.Value)));
    }
  }
}

