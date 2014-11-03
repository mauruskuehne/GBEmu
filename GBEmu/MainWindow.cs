
using System;
using System.Collections.Generic;
using System.Linq;
using MonoMac.Foundation;
using MonoMac.AppKit;
using GBEmu.Emulation;

namespace GBEmu
{
	public partial class MainWindow : MonoMac.AppKit.NSWindow
	{
		#region Constructors

		// Called when created from unmanaged code
		public MainWindow (IntPtr handle) : base (handle)
		{
			Initialize ();
		}
		
		// Called when created directly from a XIB file
		[Export ("initWithCoder:")]
		public MainWindow (NSCoder coder) : base (coder)
		{
			Initialize ();
		}
		
		// Shared initialization code
		void Initialize ()
		{
		}

		#endregion

		public void RefreshDebugData ()
		{
			this.RegisterTable.ReloadData ();
		}

		[Export ("open:")]
		public void Open (NSObject sender)
		{
			NSOpenPanel panel = new NSOpenPanel ();
			panel.AllowsMultipleSelection = false;
			panel.AllowedFileTypes = new string[] { "gb" };
			panel.RunModal ();

			var url = panel.Url;

			var data = NSData.FromUrl (url);
			var bytes = data.ToArray ();

			Controller.LoadRom (bytes);
			RegisterTable.DataSource = new CpuRegisterDataSource (Controller.Emulator.Cpu.Registers);
			RegisterTable.Delegate = new CpuRegisterTableViewDelegate ();
		}

		public MainWindowController Controller {
			get {
				return (MainWindowController)WindowController;
			}
		}
	}
}

