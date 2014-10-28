
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
    public Emulator Emulator
    {
      get;
      private set;
    }

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
      Emulator = new Emulator ();
		}

    public void LoadRom(byte[] bytes)
    {
      Emulator.LoadRom (bytes);

      var graphic = Emulator.ROM.NintendoGraphic;

      var romName = Emulator.ROM.Title;

      Emulator.Start(Mode.StepMode);
    }

    partial void ExecuteNextStep(NSObject sender)
    {
      Emulator.Cpu.NextStep();
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

