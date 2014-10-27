using System;

namespace GBEmu.Emulation
{
	public class Bit
	{
		public static InstructionParseResult TryParse (byte opcode, Registers registers, MemoryAccess memoryAccess)
		{
			UInt16 valU16 = 0;
			byte valU8 = 0;
			var res = new InstructionParseResult ();
			res.ClockCycles = 0;

      if (opcode != 0xCB)
        return null;

      opcode = memoryAccess.ReadByteAtAddress(registers.GetPC());

			switch (opcode) {
			

        case 0x47:
          Bit.BIT_b_r(() => registers.A, registers, memoryAccess);
          res.ClockCycles = 8;
				break;
        case 0x40:
          Bit.BIT_b_r(() => registers.B, registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x41:
          Bit.BIT_b_r(() => registers.C, registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x42:
          Bit.BIT_b_r(() => registers.D, registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x43:
          Bit.BIT_b_r(() => registers.E, registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x44:
          Bit.BIT_b_r(() => registers.H, registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x45:
          Bit.BIT_b_r(() => registers.L, registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x46:
          Bit.BIT_b_r(() => memoryAccess.ReadByteAtAddress(registers.HL), 
            registers, memoryAccess);
          res.ClockCycles = 16;
          break;



        case 0xC7:
          Bit.SET_b_r(() => registers.A, 
            (v) => registers.A = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0xC0:
          Bit.SET_b_r(() => registers.B, 
            (v) => registers.B = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0xC1:
          Bit.SET_b_r(() => registers.C, 
            (v) => registers.C = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0xC2:
          Bit.SET_b_r(() => registers.D, 
            (v) => registers.D = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0xC3:
          Bit.SET_b_r(() => registers.E, 
            (v) => registers.E = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0xC4:
          Bit.SET_b_r(() => registers.H, 
            (v) => registers.H = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0xC5:
          Bit.SET_b_r(() => registers.L, 
            (v) => registers.L = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0xC6:
          Bit.SET_b_r(() => memoryAccess.ReadByteAtAddress(registers.HL), 
            (v) => memoryAccess.WriteAtAddress(registers.HL, v), 
            registers, memoryAccess);
          res.ClockCycles = 16;
          break;


        case 0x87:
          Bit.RES_b_r(() => registers.A, 
            (v) => registers.A = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x80:
          Bit.RES_b_r(() => registers.B, 
            (v) => registers.B = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x81:
          Bit.RES_b_r(() => registers.C, 
            (v) => registers.C = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x82:
          Bit.RES_b_r(() => registers.D, 
            (v) => registers.D = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x83:
          Bit.RES_b_r(() => registers.E, 
            (v) => registers.E = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x84:
          Bit.RES_b_r(() => registers.H, 
            (v) => registers.H = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x85:
          Bit.RES_b_r(() => registers.L, 
            (v) => registers.L = v, 
            registers, memoryAccess);
          res.ClockCycles = 8;
          break;
        case 0x86:
          Bit.RES_b_r(() => memoryAccess.ReadByteAtAddress(registers.HL), 
            (v) => memoryAccess.WriteAtAddress(registers.HL, v), 
            registers, memoryAccess);
          res.ClockCycles = 16;
          break;

			default:
				break;
			}

			return res.ClockCycles > 0 ? res : null;
		}

    private static void BIT_b_r(Func<byte> readAction, Registers registers, MemoryAccess memory)
    {
      //0 - 7
      var bitNrToTest = memory.ReadByteAtAddress(registers.GetPC());
      byte bitToTest = (byte)(1 << bitNrToTest);

      registers.SetFlagForUnsignedByteOperation(Operation.BIT, readAction(), bitToTest);
    }

    private static void SET_b_r(Func<byte> readAction, 
      Action<byte> writeAction,
      Registers registers, MemoryAccess memory)
    {
      //0 - 7
      var bitNrToSet = memory.ReadByteAtAddress(registers.GetPC());
      byte bitToSet = (byte)(1 << bitNrToSet);

      var oldVal = readAction();
      byte newVal = (byte)(oldVal | bitToSet);

      writeAction(newVal);
    }

    private static void RES_b_r(Func<byte> readAction, 
      Action<byte> writeAction,
      Registers registers, MemoryAccess memory)
    {
      //0 - 7
      var bitNrToSet = memory.ReadByteAtAddress(registers.GetPC());
      byte bitToSet = (byte)(~(1 << bitNrToSet));

      var oldVal = readAction();
      var newVal = (byte)(oldVal | bitToSet);

      writeAction(newVal);
    }
	}
}

