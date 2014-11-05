using System;

namespace GBEmu.Emulation
{
  public class POP : OpcodeProcessor
  {
    internal static UInt16[] Opcodes {
      get {
        return new UInt16[] { 0xF1, 0xC1, 0xD1, 0xE1 };
      }
    }

    public POP (UInt16 opcode) : base(opcode)
    {
    }

    public override UInt16[] HandledOpcodes {
      get {
        return POP.Opcodes;
      }
    }

    protected override void RunInternal(IRegisterAccess registers, IMemoryAccess memoryAccess)
    {
      Register? registerToWrite = null;



      switch (Opcode)
      {
        case 0xF1:
          registerToWrite = Register.AF;
          break;
        case 0xC1:
          registerToWrite = Register.BC;
          break;
        case 0xD1:
          registerToWrite = Register.DE;
          break;
        case 0xE1:
          registerToWrite = Register.HL;
          break;
        default:
          break;
      }

      var val = memoryAccess.ReadUInt16AtAddress (registers.GetDoubleRegister(Register.SP));

      registers.SetDoubleRegister(Register.SP, (UInt16)(registers.GetDoubleRegister(Register.SP) + 2));

      registers.SetDoubleRegister(registerToWrite.Value, val);
    }
  }
}

