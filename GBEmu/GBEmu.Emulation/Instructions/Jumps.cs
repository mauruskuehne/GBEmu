using System;

namespace GBEmu.Emulation
{
  public static class Jumps
  {
    public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
    {
      var res = new InstructionParseResult();
      res.ClockCycles = 0;


      switch (opcode)
      {
        case 0xC3:

          var val = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);

          registers.PC = val;
          res.ClockCycles = 12;
          break;

        case 0xC2:

          val = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);

          if(registers.GetFlag(Flags.Z) == 0)
            registers.PC = val;
          res.ClockCycles = 12;
          break;

        case 0xCA:

          val = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);

          if(registers.GetFlag(Flags.Z) == 1)
            registers.PC = val;
          res.ClockCycles = 12;
          break;

        case 0xD2:

          val = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);

          if(registers.GetFlag(Flags.C) == 0)
            registers.PC = val;
          res.ClockCycles = 12;
          break;

        case 0xDA:

          val = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);

          if(registers.GetFlag(Flags.C) == 1)
            registers.PC = val;
          res.ClockCycles = 12;
          break;
        case 0xE9:
          registers.PC = registers.HL;
          res.ClockCycles = 4;
          break;
        case 0x18:
          registers.PC += memoryAccess.ReadByteAtAddress(registers.GetPC());
          res.ClockCycles = 8;
          break;

        case 0x20:
          var newPC = registers.PC + memoryAccess.ReadByteAtAddress(registers.GetPC());
          if(registers.GetFlag(Flags.Z) == 0)
            registers.PC = (UInt16)newPC;
          res.ClockCycles = 8;
          break;

        case 0x28:
          newPC = registers.PC + memoryAccess.ReadByteAtAddress(registers.GetPC());
          if(registers.GetFlag(Flags.Z) == 1)
            registers.PC = (UInt16)newPC;
          res.ClockCycles = 8;
          break;

        case 0x30:
          newPC = registers.PC + memoryAccess.ReadByteAtAddress(registers.GetPC());
          if(registers.GetFlag(Flags.C) == 0)
            registers.PC = (UInt16)newPC;
          res.ClockCycles = 8;
          break;

        case 0x38:
          newPC = registers.PC + memoryAccess.ReadByteAtAddress(registers.GetPC());
          if(registers.GetFlag(Flags.C) == 1)
            registers.PC = (UInt16)newPC;
          res.ClockCycles = 8;
          break;

      }

      return res.ClockCycles > 0 ? res : null;
    }
  }
}

