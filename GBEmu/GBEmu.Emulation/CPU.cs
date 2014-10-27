using System;

namespace GBEmu.Emulation
{
	public partial class CPU
	{
    public Registers Registers
    {
      get;
      private set;
    }

		MemoryAccess _memoryAccess;

		public CPU (MemoryAccess _memoryAccess)
		{
      Registers = new Registers ();
			this._memoryAccess = _memoryAccess;
      Reset();
		}


		public void Reset ()
		{
      Registers.SP = 0xFFFE;
      Registers.PC = 0x100;
		}

		public void Start ()
		{
      NextStep();
		}

    public void NextStep()
    {
      byte opcodeByte = _memoryAccess.ReadByteAtAddress (Registers.GetPC ());

      ParseOpcode (opcodeByte);
    }

		void ParseOpcode (byte opcodeByte)
		{
      var instructionResult = LD8.TryParse (opcodeByte, Registers, _memoryAccess);
			if (instructionResult != null)
				return;

      instructionResult = LD16.TryParse (opcodeByte, Registers, _memoryAccess);
			if (instructionResult != null)
				return;

      instructionResult = ALU8.TryParse (opcodeByte, Registers, _memoryAccess);
			if (instructionResult != null)
				return;

      instructionResult = ALU16.TryParse (opcodeByte, Registers, _memoryAccess);
			if (instructionResult != null)
				return;

      instructionResult = MISC.TryParse (opcodeByte, Registers, _memoryAccess);
			if (instructionResult != null)
				return;

      instructionResult = RotateAndShift.TryParse (opcodeByte, Registers, _memoryAccess);
			if (instructionResult != null)
				return;

      instructionResult = Bit.TryParse (opcodeByte, Registers, _memoryAccess);
			if (instructionResult != null)
				return;

      instructionResult = Jumps.TryParse (opcodeByte, Registers, _memoryAccess);
      if (instructionResult != null)
        return;

      instructionResult = Restarts.TryParse (opcodeByte, Registers, _memoryAccess);
      if (instructionResult != null)
        return;

      instructionResult = Returns.TryParse (opcodeByte, Registers, _memoryAccess);
      if (instructionResult != null)
        return;

      instructionResult = Calls.TryParse (opcodeByte, Registers, _memoryAccess);
      if (instructionResult != null)
        return;

		}
	}
}

