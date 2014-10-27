using System;

namespace GBEmu.Emulation
{
  public class Calls
  {
    public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
    {
      var res = new InstructionParseResult();
      res.ClockCycles = 0;


      switch (opcode)
      {
        case 0xCD:
          registers.SP -= 2;

          var addr = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          memoryAccess.WriteAtAddress(registers.SP, registers.GetPC());

          registers.PC = addr;
          res.ClockCycles = 12;
          break;



        case 0xC4:
          addr = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          if (registers.GetFlag(Flags.Z) == 1)
          {
            registers.SP -= 2;
            memoryAccess.WriteAtAddress(registers.SP, registers.GetPC());
            registers.PC = addr;
          }
          res.ClockCycles = 12;
          break;
        case 0xCC:
          addr = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          if (registers.GetFlag(Flags.Z) == 0)
          {
            registers.SP -= 2;
            memoryAccess.WriteAtAddress(registers.SP, registers.GetPC());
            registers.PC = addr;
          }
          res.ClockCycles = 12;
          break;
        case 0xD4:
          addr = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          if (registers.GetFlag(Flags.C) == 0)
          {
            registers.SP -= 2;
            memoryAccess.WriteAtAddress(registers.SP, registers.GetPC());
            registers.PC = addr;
          }
          res.ClockCycles = 12;
          break;
        case 0xDC:
          addr = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          if (registers.GetFlag(Flags.C) == 1)
          {
            registers.SP -= 2;
            memoryAccess.WriteAtAddress(registers.SP, registers.GetPC());
            registers.PC = addr;
          }
          res.ClockCycles = 12;
          break;

        default:
          break;
      }
      return res.ClockCycles > 0 ? res : null;
    }

  }
}

