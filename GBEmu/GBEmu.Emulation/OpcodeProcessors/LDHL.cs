using System;

namespace GBEmu.Emulation
{
  public class LDHL : OpcodeProcessor
  {
    internal static UInt16[] Opcodes {
      get {
        return new UInt16[] { 0xF8 };
      }
    }

    public LDHL (UInt16 opcode) : base(opcode)
    {
    }

    public override UInt16[] HandledOpcodes {
      get {
        return LD16.Opcodes;
      }
    }

    protected override void RunInternal(IRegisterAccess registers, IMemoryAccess memoryAccess)
    {
      var sp = registers.GetDoubleRegister(Register.SP);
      var valToAdd = (sbyte)memoryAccess.ReadByteAtAddress(registers.GetPC());

      var newVal = (UInt16)(sp + valToAdd);

      registers.SetDoubleRegister(Register.HL, newVal);
    }
  }
}

