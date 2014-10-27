using System;

namespace GBEmu.Emulation
{
	public class Emulator
	{
		MemoryAccess _memoryAccess;
		Display _display;
		//Input _input;
		//Speaker _speaker;

		public ROM ROM {
			get;
			set;
		}

    public CPU Cpu
    {
      get;
      private set;
    }

		public Emulator ()
		{
			_memoryAccess = new MemoryAccess ();
      Cpu = new CPU (_memoryAccess);
			_display = new Display (_memoryAccess);
			//_input = new Input (_memoryAccess);
			//_speaker = new Speaker (_memoryAccess);
		}

		public void LoadRom(byte[] romData)
		{
      Cpu.Reset ();
			_display.Reset ();

			ROM = new ROM (romData);
			_memoryAccess.InitializeWithRom (ROM);
		}

		public void Start (Mode mode)
		{
      if (mode == Mode.RunningMode)
        Cpu.Start();
		}
	}
}

