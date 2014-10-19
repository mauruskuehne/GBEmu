using System;

namespace GBEmu.Emulation
{
	public class Emulator
	{
		MemoryAccess _memoryAccess;
		CPU _cpu;
		Display _display;
		//Input _input;
		//Speaker _speaker;

		public ROM ROM {
			get;
			set;
		}

		public Emulator ()
		{
			_memoryAccess = new MemoryAccess ();
			_cpu = new CPU (_memoryAccess);
			_display = new Display (_memoryAccess);
			//_input = new Input (_memoryAccess);
			//_speaker = new Speaker (_memoryAccess);
		}

		public void LoadRom(byte[] romData)
		{
			_cpu.Reset ();
			_display.Reset ();

			ROM = new ROM (romData);
			_memoryAccess.InitializeWithRom (ROM);

		}
	}
}

