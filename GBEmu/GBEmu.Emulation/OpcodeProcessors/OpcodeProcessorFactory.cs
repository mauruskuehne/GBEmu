using System;
using System.Linq;

namespace GBEmu.Emulation
{
  public class OpcodeProcessorFactory
  {


    public OpcodeProcessorFactory()
    {
    }

    public OpcodeProcessor GetProcessorForOpcode(UInt16 opcode)
    {
      if (LD8.Opcodes.Contains(opcode))
        return new LD8(opcode);
      if (LD16.Opcodes.Contains(opcode))
        return new LD16(opcode);
      if (LDHL.Opcodes.Contains(opcode))
        return new LDHL(opcode);
      if (POP.Opcodes.Contains(opcode))
        return new POP(opcode);
      if (PUSH.Opcodes.Contains(opcode))
        return new PUSH(opcode);

      return null;
    }
  }
}