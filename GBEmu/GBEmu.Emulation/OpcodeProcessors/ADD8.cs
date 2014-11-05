using System;

namespace GBEmu.Emulation
{
  public class ADD8 : OpcodeProcessor
  {
    internal static UInt16[] Opcodes {
      get {
        return new UInt16[] { 0xF5, 0xC5, 0xD5, 0xE5 };
      }
    }

    public ADD8 (UInt16 opcode) : base(opcode)
    {
    }

    public override UInt16[] HandledOpcodes {
      get {
        return ADD8.Opcodes;
      }
    }

    protected override void RunInternal(IRegisterAccess registers, IMemoryAccess memoryAccess)
    {
    }
  }
}

