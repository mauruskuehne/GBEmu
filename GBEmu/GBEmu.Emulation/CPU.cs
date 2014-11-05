using System;

namespace GBEmu.Emulation
{
	public class ExecutionContext
	{
		/// <summary>
		/// the address where this Opcode is written at in the memory
		/// </summary>
		/// <value>The address.</value>
		public UInt16 Address {
			get;
			set;
		}

		internal OpcodeProcessor Processor { get; set;}


		public void RunOpcode (IRegisterAccess registers, IMemoryAccess memoryAccess)
		{
			Processor.Run (registers, memoryAccess);
			//TODO: Parameter auf Interfaces umstellen, welche von Klassen implementiert werden, welche ModificationLists erstellen können, oder die tatsächlichen Register/Memory sind
		}
	}

	public partial class CPU
	{
		public Registers Registers {
			get;
			private set;
		}

		MemoryAccess _memoryAccess;

		public CPU (MemoryAccess _memoryAccess)
		{
			Registers = new Registers ();
			this._memoryAccess = _memoryAccess;
			Reset ();


		}


		public void Reset ()
		{
			Registers.SP = 0xFFFE;
			Registers.PC = 0x100;
		}

		public void Start ()
		{
			//NextStep ();
		}

		public void NextStep ()
		{
			var context = PrepareOpcodeExecution ();

			context.RunOpcode (this.Registers, this._memoryAccess);

			//byte opcodeByte = _memoryAccess.ReadByteAtAddress (Registers.GetPC ());

			//ParseOpcode (opcodeByte);
		}

		ExecutionContext PrepareOpcodeExecution ()
		{
			var pcAddr = Registers.GetPC (peek: true);
			UInt16 currentOpcode = _memoryAccess.ReadByteAtAddress (pcAddr);

			OpcodeProcessor processor = null;

			if (currentOpcode == 0xCB) {
				currentOpcode = _memoryAccess.ReadUInt16AtAddress (pcAddr);
			}

			processor = this.GetProcessorForOpcode (currentOpcode);

			var context = new ExecutionContext ();

			context.Address = pcAddr;
			context.Processor = processor;

			return context;
		}


		OpcodeProcessor GetProcessorForOpcode (UInt16 currentOpcode)
		{
			//get ze opcodeprocessors...



			return null;
		}

		void ParseOpcode (byte opcodeByte)
		{
      var instructionResult = ALU8.TryParse (opcodeByte, Registers, _memoryAccess);
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

