using System;
using System.Linq;

namespace GBEmu.Emulation
{
	public abstract class OpcodeProcessor
	{
		public UInt16 Opcode {
			get;
			private set;
		}

		/// <summary>
		/// the length of the opcode in bytes (eg. Opcode=0x06 -> 1, Opcode=0xCB06 -> 2
		/// this does not take into account the amount of bytes after the opcode, eg. immediately following numbers...
		/// </summary>
		/// <value>The length of the opcode.</value>
		public int OpcodeLength {
			get	{
				return (this.Opcode & 0xCB00) > 0 ? 2 : 1;
			}
		}

		public OpcodeProcessor(UInt16 opcode)
		{
			Opcode = opcode;

			if (!HandledOpcodes.Contains (opcode))
				throw new ArgumentException ("the specified opcode is not handled by the class " + GetType());
		}

		public abstract  UInt16[] HandledOpcodes {
			get;
		}

		public void Run (IRegisterAccess registers, IMemoryAccess memoryAccess)
		{
			RunInternal (registers, memoryAccess);

		}

		protected abstract void RunInternal(IRegisterAccess registers, IMemoryAccess memoryAccess);
	}
}

