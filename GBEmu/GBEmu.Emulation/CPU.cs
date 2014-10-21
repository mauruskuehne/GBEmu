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
      byte opcodeByte = _memoryAccess.ReadByteAtAddress (_registers.GetPC());

      ParseOpcode(opcodeByte);

			//opcode.Execute (_memoryAccess, _registers);

		}

    void ParseOpcode(byte opcodeByte)
    {
      var instructionResult = LD8.TryParse(opcodeByte, _registers, _memoryAccess);
      if (instructionResult != null)
        return;
    }
	}
}

