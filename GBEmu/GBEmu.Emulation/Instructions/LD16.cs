using System;

namespace GBEmu.Emulation
{
  public static class LD16
  {
    public static InstructionParseResult TryParse(byte opcode, Registers registers, MemoryAccess memoryAccess)
    {
      var res = new InstructionParseResult();
      res.ClockCycles = 0;

      switch (opcode)
      {
        case 0x01: //LD BC, nn
          registers.BC = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          res.ClockCycles = 12;
          break;
        case 0x11: //LD DE, nn
          registers.DE = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          res.ClockCycles = 12;
          break;
        case 0x21: //LD HL, nn
          registers.HL = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          res.ClockCycles = 12;
          break;
        case 0x31: //LD SP, nn
          registers.SP = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          res.ClockCycles = 12;
          break;
        case 0xF9: //LD SP, HL
          registers.SP = memoryAccess.ReadUInt16AtAddress(registers.HL, true);
          res.ClockCycles = 8;
          break;
        case 0xF8: //LD SP, HL
          registers.SP = memoryAccess.ReadUInt16AtAddress(registers.HL, true);
          res.ClockCycles = 12;
          break;
      }

      return res.ClockCycles > 0 ? res : null;
    }
  }
}

