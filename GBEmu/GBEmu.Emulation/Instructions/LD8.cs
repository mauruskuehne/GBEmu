using System;

namespace GBEmu.Emulation
{
  public static class LD8
  {
    public static InstructionParseResult TryParse(byte opcode, Registers registers, MemoryAccess memoryAccess)
    {
      var res = new InstructionParseResult();
      res.ClockCycles = 0;
      UInt16 address = 0;
      switch (opcode)
      {
        case 0x06:
          //LD B,n
          registers.B = memoryAccess.ReadByteAtAddress(registers.GetPC());
          res.ClockCycles = 8;
          break;
        case 0x0E:
          //LD C,n
          registers.C = memoryAccess.ReadByteAtAddress(registers.GetPC());
          res.ClockCycles = 8;
          break;
        case 0x16:
          //LD D,n
          registers.D = memoryAccess.ReadByteAtAddress(registers.GetPC());
          res.ClockCycles = 8;
          break;
        case 0x1E:
          //LD E,n
          registers.E = memoryAccess.ReadByteAtAddress(registers.GetPC());
          res.ClockCycles = 8;
          break;
        case 0x26:
          //LD H,n
          registers.H = memoryAccess.ReadByteAtAddress(registers.GetPC());
          res.ClockCycles = 8;
          break;
        case 0x2E:
          //LD L,n
          registers.L = memoryAccess.ReadByteAtAddress(registers.GetPC());
          res.ClockCycles = 8;
          break;
        case 0x7F:
          //LD A,A
          //_registers.L = _memoryAccess.ReadAtAddress(_registers.GetPC());
          res.ClockCycles = 4;
          break;
        case 0x78:
          //LD A,B
          registers.A = registers.B;
          res.ClockCycles = 4;
          break;
        case 0x79:
          //LD A,C
          registers.A = registers.C;
          res.ClockCycles = 4;
          break;
        case 0x7A:
          //LD A,D
          registers.A = registers.D;
          res.ClockCycles = 4;
          break;
        case 0x7B:
          //LD A,E
          registers.A = registers.E;
          res.ClockCycles = 4;
          break;
        case 0x7C:
          //LD A,H
          registers.A = registers.H;
          res.ClockCycles = 4;
          break;
        case 0x7D:
          //LD A,L
          registers.A = registers.L;
          res.ClockCycles = 4;
          break;
        case 0x7E:
          //LD A,(HL)
          registers.A = memoryAccess.ReadByteAtAddress(registers.HL);
          res.ClockCycles = 8;
          break;
        case 0x40:
          //LD B,B
          //_registers.B = _registers.B;
          res.ClockCycles = 4;
          break;
        case 0x41:
          //LD B,C
          registers.B = registers.C;
          res.ClockCycles = 4;
          break;
        case 0x42:
          //LD B,D
          registers.B = registers.D;
          res.ClockCycles = 4;
          break;
        case 0x43:
          //LD B,E
          registers.B = registers.E;
          res.ClockCycles = 4;
          break;
        case 0x44:
          //LD B,H
          registers.B = registers.H;
          res.ClockCycles = 4;
          break;
        case 0x45:
          //LD B,L
          registers.B = registers.L;
          res.ClockCycles = 4;
          break;
        case 0x46:
          //LD B,(HL)
          registers.B = memoryAccess.ReadByteAtAddress(registers.HL);
          res.ClockCycles = 8;
          break;
        case 0x48:
          //LD C,B
          registers.C = registers.B;
          res.ClockCycles = 4;
          break;
        case 0x49:
          //LD C,C
          //_registers.C = _registers.C;
          res.ClockCycles = 4;
          break;
        case 0x4A:
          //LD C,D
          registers.C = registers.D;
          res.ClockCycles = 4;
          break;
        case 0x4B:
          //LD C,E
          registers.C = registers.E;
          res.ClockCycles = 4;
          break;
        case 0x4C:
          //LD C,H
          registers.C = registers.H;
          res.ClockCycles = 4;
          break;
        case 0x4D:
          //LD C,L
          registers.C = registers.L;
          res.ClockCycles = 4;
          break;
        case 0x4E:
          //LD C,(HL)
          registers.C = memoryAccess.ReadByteAtAddress(registers.HL);
          res.ClockCycles = 8;
          break;
        case 0x50:
          //LD D,B
          registers.D = registers.B;
          res.ClockCycles = 4;
          break;
        case 0x51:
          //LD D,C
          registers.D = registers.C;
          res.ClockCycles = 4;
          break;
        case 0x52:
          //LD D,D
          //_registers.D = _registers.D;
          res.ClockCycles = 4;
          break;
        case 0x53:
          //LD D,E
          registers.D = registers.E;
          res.ClockCycles = 4;
          break;
        case 0x54:
          //LD D,H
          registers.D = registers.H;
          res.ClockCycles = 4;
          break;
        case 0x55:
          //LD D,L
          registers.D = registers.L;
          res.ClockCycles = 4;
          break;
        case 0x56:
          //LD D,(HL)
          registers.D = memoryAccess.ReadByteAtAddress(registers.HL);
          res.ClockCycles = 8;
          break;
        case 0x58:
          //LD E,B
          registers.E = registers.B;
          res.ClockCycles = 4;
          break;
        case 0x59:
          //LD E,C
          registers.E = registers.C;
          res.ClockCycles = 4;
          break;
        case 0x5A:
          //LD E,D
          registers.E = registers.D;
          res.ClockCycles = 4;
          break;
        case 0x5B:
          //LD E,E
          //_registers.E = _registers.E;
          res.ClockCycles = 4;
          break;
        case 0x5C:
          //LD E,H
          registers.E = registers.H;
          res.ClockCycles = 4;
          break;
        case 0x5D:
          //LD E,L
          registers.E = registers.L;
          res.ClockCycles = 4;
          break;
        case 0x5E:
          //LD E,(HL)
          registers.E = memoryAccess.ReadByteAtAddress(registers.HL);
          res.ClockCycles = 8;
          break;
        case 0x60:
          //LD H,B
          registers.H = registers.B;
          res.ClockCycles = 4;
          break;
        case 0x61:
          //LD H,C
          registers.H = registers.C;
          res.ClockCycles = 4;
          break;
        case 0x62:
          //LD H,D
          registers.H = registers.D;
          res.ClockCycles = 4;
          break;
        case 0x63:
          //LD H,E
          registers.H = registers.E;
          res.ClockCycles = 4;
          break;
        case 0x64:
          //LD H,H
          //_registers.H = _registers.H;
          res.ClockCycles = 4;
          break;
        case 0x65:
          //LD H,L
          registers.H = registers.L;
          res.ClockCycles = 4;
          break;
        case 0x66:
          //LD H,(HL)
          registers.H = memoryAccess.ReadByteAtAddress(registers.HL);
          res.ClockCycles = 8;
          break;
        case 0x68:
          //LD L,B
          registers.L = registers.B;
          res.ClockCycles = 4;
          break;
        case 0x69:
          //LD L,C
          registers.L = registers.C;
          res.ClockCycles = 4;
          break;
        case 0x6A:
          //LD L,D
          registers.L = registers.D;
          res.ClockCycles = 4;
          break;
        case 0x6B:
          //LD L,E
          registers.L = registers.E;
          res.ClockCycles = 4;
          break;
        case 0x6C:
          //LD L,H
          registers.L = registers.H;
          res.ClockCycles = 4;
          break;
        case 0x6D:
          //LD L,L
          //_registers.L = _registers.L;
          res.ClockCycles = 4;
          break;
        case 0x6E:
          //LD L,(HL)
          registers.L = memoryAccess.ReadByteAtAddress(registers.HL);
          res.ClockCycles = 8;
          break;
        case 0x70:
          //LD (HL), B
          memoryAccess.WriteAtAddress(registers.HL, registers.B);
          res.ClockCycles = 8;
          break;
        case 0x71:
          //LD (HL), C
          memoryAccess.WriteAtAddress(registers.HL, registers.C);
          res.ClockCycles = 8;
          break;
        case 0x72:
          //LD (HL), D
          memoryAccess.WriteAtAddress(registers.HL, registers.D);
          res.ClockCycles = 8;
          break;
        case 0x73:
          //LD (HL), E
          memoryAccess.WriteAtAddress(registers.HL, registers.E);
          res.ClockCycles = 8;
          break;
        case 0x74:
          //LD (HL), H
          memoryAccess.WriteAtAddress(registers.HL, registers.H);
          res.ClockCycles = 8;
          break;
        case 0x75:
          //LD (HL), L
          memoryAccess.WriteAtAddress(registers.HL, registers.L);
          res.ClockCycles = 8;
          break;
        case 0x36:
          //LD (HL), n
          memoryAccess.WriteAtAddress(registers.HL, memoryAccess.ReadByteAtAddress(registers.GetPC()));
          res.ClockCycles = 12;
          break;
        case 0x0A:
          //LD A,(BC)
          registers.A = memoryAccess.ReadByteAtAddress(registers.BC);
          res.ClockCycles = 8;
          break;
        case 0x1A:
          //LD A,(DE)
          registers.A = memoryAccess.ReadByteAtAddress(registers.DE);
          res.ClockCycles = 8;
          break;
        case 0xFA:
          //LD A,(nn)
          address = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          registers.A = memoryAccess.ReadByteAtAddress(address);
          res.ClockCycles = 16;
          break;
        case 0x3E:
          //LD A,#
          registers.A = memoryAccess.ReadByteAtAddress(registers.GetPC());
          res.ClockCycles = 8;
          break;
        case 0x47:
          // LD B, A
          registers.B = registers.A;
          res.ClockCycles = 4;
          break;
        case 0x4F:
          // LD C, A
          registers.C = registers.A;
          res.ClockCycles = 4;
          break;
        case 0x57:
          // LD D, A
          registers.D = registers.A;
          res.ClockCycles = 4;
          break;
        case 0x5F:
          // LD E, A
          registers.E = registers.A;
          res.ClockCycles = 4;
          break;
        case 0x67:
          // LD H, A
          registers.H = registers.A;
          res.ClockCycles = 4;
          break;
        case 0x6F:
          // LD L, A
          registers.L = registers.A;
          res.ClockCycles = 4;
          break;
        case 0x02:
          // LD (BC), A
          memoryAccess.WriteAtAddress(registers.BC, registers.A);
          res.ClockCycles = 8;
          break;
        case 0x12:
          // LD (DE), A
          memoryAccess.WriteAtAddress(registers.DE, registers.A);
          res.ClockCycles = 8;
          break;
        case 0x77:
          // LD (HL), A
          memoryAccess.WriteAtAddress(registers.HL, registers.A);
          res.ClockCycles = 8;
          break;
        case 0xEA:
          // LD (nn), A
          address = memoryAccess.ReadUInt16AtAddress(registers.GetPC(2), true);
          memoryAccess.WriteAtAddress(address, registers.A);
          res.ClockCycles = 16;
          break;
        case 0xF2:
          //LD A,($FF00 + C)
          address = (UInt16)(0xFF00 + registers.C);
          registers.A = memoryAccess.ReadByteAtAddress(address);
          res.ClockCycles = 8;
          break;
        case 0xE2:
          //LD ($FF00 + C), A
          address = (UInt16)(0xFF00 + registers.C);
          memoryAccess.WriteAtAddress(address, registers.A);
          res.ClockCycles = 8;
          break;
        case 0x3A:
          // LDD A, (HL)
          registers.A = memoryAccess.ReadByteAtAddress(registers.HL--);
          res.ClockCycles = 8;
          break;
        case 0x32:
          // LDD (HL), A 
          memoryAccess.WriteAtAddress(registers.HL--, registers.A);
          res.ClockCycles = 8;
          break;
        case 0x2A:
          // LDI A, (HL)
          registers.A = memoryAccess.ReadByteAtAddress(registers.HL++);
          res.ClockCycles = 8;
          break;
        case 0x22:
          // LDI (HL), A 
          memoryAccess.WriteAtAddress(registers.HL++, registers.A);
          res.ClockCycles = 8;
          break;
        case 0xE0:
          address = (UInt16)(0xFF00 + memoryAccess.ReadByteAtAddress(registers.GetPC()));
          memoryAccess.WriteAtAddress(address, registers.A);
          res.ClockCycles = 12;
          break;
        case 0xF0:
          address = (UInt16)(0xFF00 + memoryAccess.ReadByteAtAddress(registers.GetPC()));
          registers.A = memoryAccess.ReadByteAtAddress(address);
          res.ClockCycles = 12;
          break;
      }

      return res.ClockCycles > 0 ? res : null;
    }
  }
}

