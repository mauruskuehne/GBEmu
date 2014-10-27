using System;

namespace GBEmu.Emulation
{
  public class Restarts
  {
    public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
    {
      var res = new InstructionParseResult();
      res.ClockCycles = 0;


      switch (opcode)
      {
        case 0xC7:
          Restarts.RST_n(0x00, registers, memoryAccess);
          res.ClockCycles = 32;
          break;
        case 0xCF:
          Restarts.RST_n(0x08, registers, memoryAccess);
          res.ClockCycles = 32;
          break;
        case 0xD7:
          Restarts.RST_n(0x10, registers, memoryAccess);
          res.ClockCycles = 32;
          break;
        case 0xDF:
          Restarts.RST_n(0x18, registers, memoryAccess);
          res.ClockCycles = 32;
          break;
        case 0xE7:
          Restarts.RST_n(0x20, registers, memoryAccess);
          res.ClockCycles = 32;
          break;
        case 0xEF:
          Restarts.RST_n(0x28, registers, memoryAccess);
          res.ClockCycles = 32;
          break;
        case 0xF7:
          Restarts.RST_n(0x30, registers, memoryAccess);
          res.ClockCycles = 32;
          break;
        case 0xFF:
          Restarts.RST_n(0x38, registers, memoryAccess);
          res.ClockCycles = 32;
          break;
      }

      return res.ClockCycles > 0 ? res : null;
    }

    private static void RST_n(UInt16 offset, Registers register, 
      MemoryAccess memoryAccess)
    {
      var currAddr = register.GetPC();
      register.SP -= 2;
      memoryAccess.WriteAtAddress(register.SP, currAddr);

      register.SP = offset;
    }
  }
}

