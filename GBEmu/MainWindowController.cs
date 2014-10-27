
using System;
using System.Collections.Generic;
using System.Linq;
using MonoMac.Foundation;
using MonoMac.AppKit;
using GBEmu.Emulation;

namespace GBEmu
{
	public partial class MainWindowController : MonoMac.AppKit.NSWindowController
  {
    Emulator _emulator;

		#region Constructors

		// Called when created from unmanaged code
		public MainWindowController (IntPtr handle) : base (handle)
		{
			Initialize ();
		}
		
		// Called when created directly from a XIB file
		[Export ("initWithCoder:")]
		public MainWindowController (NSCoder coder) : base (coder)
		{
			Initialize ();
		}
		
		// Call to load from the XIB/NIB file
		public MainWindowController () : base ("MainWindow")
		{
			Initialize ();
		}
		
		// Shared initialization code
		void Initialize ()
    {
      _emulator = new Emulator ();
		}

    public void LoadRom(byte[] bytes)
    {
      _emulator.LoadRom (bytes);

      var graphic = _emulator.ROM.NintendoGraphic;

      var romName = _emulator.ROM.Title;

      _emulator.Start(Mode.StepMode);
    }

    partial void ExecuteNextStep(NSObject sender)
    {
      _emulator.Cpu.NextStep();
    }

		#endregion

		//strongly typed window accessor
		public new MainWindow Window {
			get {
				return (MainWindow)base.Window;
			}
		}
	}
}

