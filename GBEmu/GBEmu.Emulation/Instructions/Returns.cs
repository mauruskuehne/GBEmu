using System;

namespace GBEmu.Emulation
{
  public class Returns
  {
    public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
    {
      var res = new InstructionParseResult();
      res.ClockCycles = 0;


      switch (opcode)
      {
        case 0xC9:
          var addr = memoryAccess.ReadUInt16AtAddress(registers.SP);
          registers.SP += 2;
          registers.PC = addr;
          res.ClockCycles = 8;
          break;

        case 0xC0:
          if (registers.GetFlag(Flags.Z) == 0)
          {
            addr = memoryAccess.ReadUInt16AtAddress(registers.SP);
            registers.SP += 2;
            registers.PC = addr;
          }
          res.ClockCycles = 8;
          break;
        case 0xC8:
          if (registers.GetFlag(Flags.Z) == 1)
          {
            addr = memoryAccess.ReadUInt16AtAddress(registers.SP);
            registers.SP += 2;
            registers.PC = addr;
          }
          res.ClockCycles = 8;
          break;
        case 0xD0:
          if (registers.GetFlag(Flags.C) == 0)
          {
            addr = memoryAccess.ReadUInt16AtAddress(registers.SP);
            registers.SP += 2;
            registers.PC = addr;
          }
          res.ClockCycles = 8;
          break;
        case 0xD8:
          if (registers.GetFlag(Flags.C) == 1)
          {
            addr = memoryAccess.ReadUInt16AtAddress(registers.SP);
            registers.SP += 2;
            registers.PC = addr;
          }
          res.ClockCycles = 8;
          break;

        case 0xD9:
          addr = memoryAccess.ReadUInt16AtAddress(registers.SP);
          registers.SP += 2;
          registers.PC = addr;
          res.ClockCycles = 8;
          break;
      }

      return res.ClockCycles > 0 ? res : null;
    }
  }
}

