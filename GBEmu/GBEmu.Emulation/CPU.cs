using System;

namespace GBEmu.Emulation
{
	public partial class CPU
	{
		Registers _registers;

		MemoryAccess _memoryAccess;

		public CPU (MemoryAccess _memoryAccess)
		{
			_registers = new Registers ();
			this._memoryAccess = _memoryAccess;
			this.FillOpCodeDictionary ();
		}

		partial void FillOpCodeDictionary ();

		public void Reset ()
		{
			_registers.SP = 0xFFFE;
			_registers.PC = 0x100;
		}

		public void Start ()
		{
      byte opcodeByte = _memoryAccess.ReadAtAddress (_registers.GetPC());

      uint clockCycles = 0;
      switch (opcodeByte)
      {
        case 0x06: //LD B,n
          _registers.B = _memoryAccess.ReadAtAddress(_registers.GetPC());
          clockCycles = 8;
          break;
        case 0x0E: //LD C,n
          _registers.C = _memoryAccess.ReadAtAddress(_registers.GetPC());
          clockCycles = 8;
          break;
        case 0x16: //LD D,n
          _registers.D = _memoryAccess.ReadAtAddress(_registers.GetPC());
          clockCycles = 8;
          break;
        case 0x1E: //LD E,n
          _registers.E = _memoryAccess.ReadAtAddress(_registers.GetPC());
          clockCycles = 8;
          break;
        case 0x26: //LD H,n
          _registers.H = _memoryAccess.ReadAtAddress(_registers.GetPC());
          clockCycles = 8;
          break;
        case 0x2E: //LD L,n
          _registers.L = _memoryAccess.ReadAtAddress(_registers.GetPC());
          clockCycles = 8;
          break;
        case 0x7F: //LD A,A
          //_registers.L = _memoryAccess.ReadAtAddress(_registers.GetPC());
          clockCycles = 4;
          break;
        case 0x78: //LD A,B
          _registers.A = _registers.B;
          clockCycles = 4;
          break;
        case 0x79: //LD A,C
          _registers.A = _registers.C;
          clockCycles = 4;
          break;
        case 0x7A: //LD A,D
          _registers.A = _registers.D;
          clockCycles = 4;
          break;
        case 0x7B: //LD A,E
          _registers.A = _registers.E;
          clockCycles = 4;
          break;
        case 0x7C: //LD A,H
          _registers.A = _registers.H;
          clockCycles = 4;
          break;
        case 0x7D: //LD A,L
          _registers.A = _registers.L;
          clockCycles = 4;
          break;
        case 0x7E: //LD A,(HL)
          _registers.A = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;

        case 0x40: //LD B,B
          //_registers.B = _registers.B;
          clockCycles = 4;
          break;
        case 0x41: //LD B,C
          _registers.B = _registers.C;
          clockCycles = 4;
          break;
        case 0x42: //LD B,D
          _registers.B = _registers.D;
          clockCycles = 4;
          break;
        case 0x43: //LD B,E
          _registers.B = _registers.E;
          clockCycles = 4;
          break;
        case 0x44: //LD B,H
          _registers.B = _registers.H;
          clockCycles = 4;
          break;
        case 0x45: //LD B,L
          _registers.B = _registers.L;
          clockCycles = 4;
          break;
        case 0x46: //LD B,(HL)
          _registers.B = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;

        case 0x48: //LD C,B
          _registers.C = _registers.B;
          clockCycles = 4;
          break;
        case 0x49: //LD C,C
          //_registers.C = _registers.C;
          clockCycles = 4;
          break;
        case 0x4A: //LD C,D
          _registers.C = _registers.D;
          clockCycles = 4;
          break;
        case 0x4B: //LD C,E
          _registers.C = _registers.E;
          clockCycles = 4;
          break;
        case 0x4C: //LD C,H
          _registers.C = _registers.H;
          clockCycles = 4;
          break;
        case 0x4D: //LD C,L
          _registers.C = _registers.L;
          clockCycles = 4;
          break;
        case 0x4E: //LD C,(HL)
          _registers.C = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;

        case 0x50: //LD D,B
          _registers.D = _registers.B;
          clockCycles = 4;
          break;
        case 0x51: //LD D,C
          _registers.D = _registers.C;
          clockCycles = 4;
          break;
        case 0x52: //LD D,D
          //_registers.D = _registers.D;
          clockCycles = 4;
          break;
        case 0x53: //LD D,E
          _registers.D = _registers.E;
          clockCycles = 4;
          break;
        case 0x54: //LD D,H
          _registers.D = _registers.H;
          clockCycles = 4;
          break;
        case 0x55: //LD D,L
          _registers.D = _registers.L;
          clockCycles = 4;
          break;
        case 0x56: //LD D,(HL)
          _registers.D = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;

        case 0x58: //LD E,B
          _registers.E = _registers.B;
          clockCycles = 4;
          break;
        case 0x59: //LD E,C
          _registers.E = _registers.C;
          clockCycles = 4;
          break;
        case 0x5A: //LD E,D
          _registers.E = _registers.D;
          clockCycles = 4;
          break;
        case 0x5B: //LD E,E
          //_registers.E = _registers.E;
          clockCycles = 4;
          break;
        case 0x5C: //LD E,H
          _registers.E = _registers.H;
          clockCycles = 4;
          break;
        case 0x5D: //LD E,L
          _registers.E = _registers.L;
          clockCycles = 4;
          break;
        case 0x5E: //LD E,(HL)
          _registers.E = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;

        case 0x60: //LD H,B
          _registers.H = _registers.B;
          clockCycles = 4;
          break;
        case 0x61: //LD H,C
          _registers.H = _registers.C;
          clockCycles = 4;
          break;
        case 0x62: //LD H,D
          _registers.H = _registers.D;
          clockCycles = 4;
          break;
        case 0x63: //LD H,E
          _registers.H = _registers.E;
          clockCycles = 4;
          break;
        case 0x64: //LD H,H
          //_registers.H = _registers.H;
          clockCycles = 4;
          break;
        case 0x65: //LD H,L
          _registers.H = _registers.L;
          clockCycles = 4;
          break;
        case 0x66: //LD H,(HL)
          _registers.H = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;

        case 0x68: //LD L,B
          _registers.L = _registers.B;
          clockCycles = 4;
          break;
        case 0x69: //LD L,C
          _registers.L = _registers.C;
          clockCycles = 4;
          break;
        case 0x6A: //LD L,D
          _registers.L = _registers.D;
          clockCycles = 4;
          break;
        case 0x6B: //LD L,E
          _registers.L = _registers.E;
          clockCycles = 4;
          break;
        case 0x6C: //LD L,H
          _registers.L = _registers.H;
          clockCycles = 4;
          break;
        case 0x6D: //LD L,L
          //_registers.L = _registers.L;
          clockCycles = 4;
          break;
        case 0x6E: //LD L,(HL)
          _registers.L = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;

        case 0x70: //LD (HL), B
          _memoryAccess.WriteAtAddress(_registers.HL, _registers.B);
          clockCycles = 8;
          break;
        case 0x71: //LD (HL), C
          _memoryAccess.WriteAtAddress(_registers.HL, _registers.C);
          clockCycles = 8;
          break;
        case 0x72: //LD (HL), D
          _memoryAccess.WriteAtAddress(_registers.HL, _registers.D);
          clockCycles = 8;
          break;
        case 0x73: //LD (HL), E
          _memoryAccess.WriteAtAddress(_registers.HL, _registers.E);
          clockCycles = 8;
          break;
        case 0x74: //LD (HL), H
          _memoryAccess.WriteAtAddress(_registers.HL, _registers.H);
          clockCycles = 8;
          break;
        case 0x75: //LD (HL), L
          _memoryAccess.WriteAtAddress(_registers.HL, _registers.L);
          clockCycles = 8;
          break;
        case 0x36: //LD (HL), n
          _memoryAccess.WriteAtAddress(_registers.HL, _memoryAccess.ReadAtAddress(_registers.GetPC()));
          clockCycles = 12;
          break;



        case 0x7F: //LD A,A
          //_registers.A = _registers.A;
          clockCycles = 4;
          break;
        case 0x78: //LD A,B
          _registers.A = _registers.B;
          clockCycles = 4;
          break;
        case 0x79: //LD A,C
          _registers.L = _registers.C;
          clockCycles = 4;
          break;
        case 0x7A: //LD A,D
          _registers.L = _registers.D;
          clockCycles = 4;
          break;
        case 0x7B: //LD A,E
          _registers.L = _registers.E;
          clockCycles = 4;
          break;
        case 0x7C: //LD A,H
          _registers.A = _registers.H;
          clockCycles = 4;
          break;
        case 0x7D: //LD A,L
          _registers.L = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;
        case 0x0A: //LD A,(BC)
          _registers.L = _registers.D;
          clockCycles = 8;
          break;
        case 0x1A: //LD A,(DE)
          _registers.L = _registers.E;
          clockCycles = 8;
          break;
        case 0x7E: //LD A,(HL)
          _registers.L = _registers.H;
          clockCycles = 8;
          break;
        case 0xFA: //LD A,(nn)
          _registers.A = _registers.L;
          clockCycles = 8;
          break;
        case 0x3E: //LD A,#
          _registers.L = _memoryAccess.ReadAtAddress(_registers.HL);
          clockCycles = 8;
          break;
      }

			//opcode.Execute (_memoryAccess, _registers);

			_registers.PC++;
		}
	}
}

